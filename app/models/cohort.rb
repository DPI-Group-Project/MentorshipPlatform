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
  def paring_number
    matches = Match.where(cohort_id: self.id)
    matches.size
  end
end
