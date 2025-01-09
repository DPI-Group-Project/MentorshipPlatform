# == Schema Information
#
# Table name: cohort_members
#
#  cohort_id  :bigint           not null
#  email      :string           not null
#  role       :enum
#  capacity   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class CohortMember < ApplicationRecord
  self.primary_key = "email"
  
  enum role: { mentor: "mentor", mentee: "mentee" }

  has_one :user, primary_key: "email", foreign_key: "email"
  belongs_to :cohort, optional: false, class_name: "Cohort"
  validates :email, uniqueness: true
end
