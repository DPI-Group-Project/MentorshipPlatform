# == Schema Information
#
# Table name: matches
#
#  id         :bigint           not null, primary key
#  mentor_id  :bigint           not null
#  mentee_id  :bigint           not null
#  cohort_id  :bigint           not null
#  active     :boolean
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Match < ApplicationRecord
  belongs_to :mentor, required: true, class_name: "User", foreign_key: "mentor_id"
  belongs_to :mentee, required: true, class_name: "User", foreign_key: "mentee_id"
  belongs_to :cohort, required: true, class_name: "Cohort", foreign_key: "cohort_id"
  has_many :meetings, class_name: "Meeting", foreign_key: "match_id", dependent: :destroy
  has_many :reviews, class_name: "Review", foreign_key: "match_id", dependent: :destroy
  
  
end
