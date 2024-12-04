# == Schema Information
#
# Table name: cohort_members
#
#  id         :bigint           not null, primary key
#  email      :string           not null
#  cohort_id  :bigint           not null
#  role       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  capacity   :integer
#
class CohortMember < ApplicationRecord
  enum role: { mentor: "mentor", mentee: "mentee" }

  has_one :user, primary_key: "email", foreign_key: "email"
  belongs_to :cohort, optional: false, class_name: "Cohort"
  validates :email, uniqueness: true
end
