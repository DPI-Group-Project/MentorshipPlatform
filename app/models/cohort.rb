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
  belongs_to :creator, required: true, class_name: "User", foreign_key: "creator_id"
  belongs_to :program, required: true, class_name: "Program", foreign_key: "program_id"
  has_many :members, class_name: "CohortMember", foreign_key: "cohort_id", dependent: :destroy
  has_many :matches, class_name: "Match", foreign_key: "cohort_id", dependent: :destroy
  
  after_commit :start_scheduler_on_creation, on: [:create, :update, :destroy]

  def running?
    if end_date > Date.today
      true
    else
      false
    end
  end
  def shortlist_creation_open?
    current_time = Time.current.in_time_zone.utc
    current_time_in_user_zone = current_time.strftime('%Y-%m-%d %H:%M:%S UTC')
    if shortlist_start_time <= current_time_in_user_zone && shortlist_end_time >= current_time_in_user_zone
      'open'
    else
      'closed'
    end
  end
  def pairing_number
    matches = Match.where(cohort_id: self.id)
    matches.size
  end

  # Creates thread that runs matching code in matches controller
  def start_scheduler_on_creation
    unless  @scheduler_thread&.alive?
      Rails.logger.info "Creating new scheduler thread..."
      @scheduler_thread = Thread.new(name: 'MatchingThreadInCohortModel') do
        require 'rufus-scheduler'
        # Initialize a new scheduler instance
        scheduler = Rufus::Scheduler.new
        cohorts = Cohort.where.not(shortlist_start_time: nil)
              .where.not(shortlist_end_time: nil)

        cohorts.each_with_index do |cohort, index|
          shortlist_end_date = cohort.shortlist_end_time.in_time_zone.utc
          scheduler.at shortlist_end_date do
            MatchesController.new.create_for_cohort(cohort)
          end
        end
      end
    end
  end
  def send_matching_results_emails
    emails_of_cohort_members = CohortMember.where(cohort_id: self.id).pluck(:email)
    matched_users = []
    unmatched_users = []

    emails_of_cohort_members.each do |email|
      user = User.find_by(email: email)

      if user.matched?
        matched_users << user.email
      else
        unmatched_users << user.email
      end
    end
    p matched_users
    p unmatched_users
    p "Emails sent"
  end
end
