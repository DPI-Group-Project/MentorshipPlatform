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
  belongs_to :user, required: true, class_name: 'User', primary_key: 'email', foreign_key: 'email'
  belongs_to :cohort, required: true, class_name: 'Cohort', foreign_key: 'cohort_id'

  before_create :find_or_create_user
  attr_accessor :cohort_member_attributes

  private

  def find_or_create_user
    pp cohort_member_attributes
  end
end
