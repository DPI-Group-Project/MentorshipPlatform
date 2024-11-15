# == Schema Information
#
# Table name: cohorts
#
#  id                   :bigint           not null, primary key
#  program_id           :bigint           not null
#  cohort_name          :string
#  description          :text
#  start_date           :datetime
#  end_date             :datetime
#  creator_id           :bigint           not null
#  contact_id           :bigint           not null
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  required_meetings    :integer
#  shortlist_start_time :datetime
#  shortlist_end_time   :datetime
#
class Cohort < ApplicationRecord
  belongs_to :creator, optional: false, class_name: "User"
  belongs_to :program, optional: false, class_name: "Program"
  has_many :members, class_name: "CohortMember", dependent: :destroy
  has_many :matches, class_name: "Match", dependent: :destroy

  validates :start_date, presence: { message: "Start Date cannot be blank" }
  validates :end_date, presence: { message: "End Date be blank" }
  validates :shortlist_start_time, presence: { message: "Shortlist start time cannot be blank" }
  validates :shortlist_end_time, presence: { message: "Shortlist end time cannot be blank" }
  validates :required_meetings, presence: { message: "Required meetings cannot be blank" }

  after_commit :start_scheduler_thread, on: %i[create update destroy]

  def running?
    end_date > Time.zone.today
  end

  def shortlist_creation_open?
    current_time = Time.current.in_time_zone.utc
    current_time_in_user_zone = current_time.strftime("%Y-%m-%d %H:%M:%S UTC")
    if shortlist_start_time <= current_time_in_user_zone && shortlist_end_time >= current_time_in_user_zone
      "open"
    else
      "closed"
    end
  end

  def pairing_number
    matches = Match.where(cohort_id: id)
    matches.size
  end

  # Creates thread that runs matching code in matches controller
  def start_scheduler_thread
    return if @scheduler_thread&.alive?

    Rails.logger.info "Creating new scheduler thread..."
    @scheduler_thread = Thread.new(name: "MatchingThreadInCohortModel") do
      require "rufus-scheduler"
      # Initialize a new scheduler instance
      scheduler = Rufus::Scheduler.new
      cohorts = Cohort.where.not(start_date: nil)
                      .where.not(end_date: nil)
                      .where.not(shortlist_start_time: nil)
                      .where.not(shortlist_end_time: nil)

      cohorts.each do |cohort|
        shortlist_end_date = cohort.shortlist_end_time.in_time_zone.utc

        # trigger matching when the scheduler is reached
        scheduler.at shortlist_end_date do
          MatchesController.new.create_for_cohort(cohort)
        end

        # Schedule the email notification at the shortlist start time
        scheduler.at cohort.shortlist_start_time.in_time_zone.utc do
          cohort.members.each do |member|
            CohortMailer.shortlist_start_notification(member.user, cohort).deliver_later!
          end
        end

        subtract_2_weeks = cohort.end_date - 14.days
        Rails.logger.debug subtract_2_weeks

        # send warning email to admin that cohort is ending in 2 weeks
        scheduler.at subtract_2_weeks do
          CohortMailer.two_week_warning(creator.email, cohort).deliver_later!

          cohort_members = CohortMember.where(cohort_id: cohort.id)
          # remind each cohort member about survey
          cohort_members.each do |member|
            Rails.logger.debug "#{member} POOP!"
            CohortMailer.survey_reminder(member.mentor, cohort).deliver_later!
            CohortMailer.survey_reminder(member.mentee, cohort).deliver_later!
          end

          CohortMailer.survey_reminder(nil, cohort, cohort.creator.email).deliver_later!
        end
      end
    end
  end

  def send_matching_results_emails
    emails_of_cohort_members = CohortMember.where(cohort_id: id).pluck(:email)
    matched_users = []
    unmatched_users = []

    emails_of_cohort_members.each do |email|
      user = User.find_by(email: email)

      if user.matched?
        matched_users << user
      else
        ShortList.where(mentee_id: user.id).destroy_all
        unmatched_users << user
      end
    end
    Rails.logger.debug "matched emails #{matched_users}"
    Rails.logger.debug "unmatched emails #{unmatched_users}"

    # if there are any unmatched mentees
    if unmatched_users.any?
      unmatched_users.each do |user|
        # opens shortlist creation again for 3 days
        update!(shortlist_end_time: shortlist_end_time + 3.days)
        CohortMailer.unmatched_notification(user, self).deliver_later
      end
    else
      # send email to admin that matching is complete (if all mentees are matched)
      CohortMailer.matching_complete_notification(creator.email, self).deliver_later
    end
    Rails.logger.debug "Emails sent for unmactched users"
  end
end
