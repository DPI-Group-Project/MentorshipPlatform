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

  # Validations
  validates :start_date, presence: { message: "Start Date cannot be blank" }
  validates :end_date, presence: { message: "End Date cannot be blank" }
  validates :shortlist_start_time, presence: { message: "Shortlist start time cannot be blank" }
  validates :shortlist_end_time, presence: { message: "Shortlist end time cannot be blank" }
  validates :required_meetings, presence: { message: "Required meetings cannot be blank" }

  # Callbacks
  after_commit :schedule_matching_tasks, on: %i[create update destroy]

  # Instance Methods

  def running?
    end_date > Time.zone.today
  end

  def shortlist_creation_open?
    current_time = Time.zone.now
    if shortlist_start_time <= current_time && shortlist_end_time >= current_time
      "open"
    else
      "closed"
    end
  end

  def pairing_number
    matches = Match.where(cohort_id: id)
    matches.size
  end

  def unmatched_mentees
    unmatched_users[:mentees]
  end

  def unmatched_mentors
    unmatched_users[:mentors]
  end

  # Match Handling
  def create_matches
    CohortMatchingService.new(self).call
  end

  # Background Scheduler (Email Notifications and Matching)
  def schedule_matching_tasks
    CohortSchedulerJob.perform_now(id)
  end

  private

  # Find unmatched users for this cohort
  def unmatched_users
    emails_of_cohort_members = CohortMember.where(cohort_id: id).pluck(:email)
    unmatched_mentees = []
    unmatched_mentors = []

    emails_of_cohort_members.each do |email|
      user = User.find_by(email: email)
      next unless user

      if !user.matched? && user.role == "mentee"
        unmatched_mentees << user
      elsif !user.matched? && user.role == "mentor"
        unmatched_mentors << user
      end
    end

    { mentees: unmatched_mentees, mentors: unmatched_mentors }
  end
end
