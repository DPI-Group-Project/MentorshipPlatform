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
end
