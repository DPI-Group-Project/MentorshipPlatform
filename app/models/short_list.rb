# == Schema Information
#
# Table name: short_lists
#
#  id         :bigint           not null, primary key
#  mentor_id  :bigint           not null
#  mentee_id  :bigint           not null
#  cohort_id  :bigint           not null
#  ranking    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class ShortList < ApplicationRecord
  belongs_to :mentor, optional: false, class_name: "User"
  belongs_to :mentee, optional: false, class_name: "User"
  belongs_to :cohort, optional: false, class_name: "Cohort"

  validates :cohort_id, presence: true
  validates :mentor_id, presence: true
  validates :mentee_id, presence: true
  validates :ranking, numericality: { only_integer: true, greater_than: 0, allow_nil: true }
  validates :mentor_id, uniqueness: { scope: %i[mentee_id cohort_id], message: "Pairing already exists in this cohort" }

  scope :for_cohort, ->(cohort_id) { where(cohort_id: cohort_id) }
  scope :ordered, -> { order(:created_at, :ranking) }
end
