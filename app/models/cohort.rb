# == Schema Information
#
# Table name: cohorts
#
#  id                :bigint           not null, primary key
#  program_id        :bigint           not null
#  cohort_name       :string
#  description       :text
#  start_date        :datetime
#  end_date          :datetime
#  creator_id        :bigint           not null
#  contact_id        :bigint           not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  required_meetings :integer
#
class Cohort < ApplicationRecord
  belongs_to :creator, required: true, class_name: "User", foreign_key: "creator_id"
  belongs_to :program, required: true, class_name: "Program", foreign_key: "program_id"
  has_many :members, class_name: "CohortMember", foreign_key: "cohort_id", dependent: :destroy
  has_many :matches, class_name: "Match", foreign_key: "cohort_id", dependent: :destroy
  
  def running?
    if end_date > Date.today
      true
    else
      false
    end
  end
  def shortlist_creation_open?
    formatted_time = Time.current.utc.strftime('%Y-%m-%d %H:%M:%S UTC')
    user_local_time = formatted_time
    user_timezone = 'America/Chicago'
    user_time = Time.zone.parse(user_local_time).in_time_zone(user_timezone)
    current_time_in_user_zone = Time.current.in_time_zone(user_timezone)
    time = current_time_in_user_zone.strftime('%Y-%m-%d %H:%M:%S UTC')
    p "START: #{shortlist_start_time}"
    p "NOW: #{ time}"
    p "END: #{shortlist_end_time}"

    if shortlist_start_time <=  time && shortlist_end_time >=  time
      p 'open'
      return 'open'
    else
      p 'closed'
      return 'closed'
    end
  end
  def pairing_number
    matches = Match.where(cohort_id: self.id)
    matches.size
  end
end
