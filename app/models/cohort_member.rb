# == Schema Information
#
# Table name: cohort_members
#
#  id         :bigint           not null, primary key
#  user_id    :bigint           not null
#  cohort_id  :bigint           not null
#  role       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class CohortMember < ApplicationRecord
  belongs_to :user, required: true, class_name: "User", foreign_key: "user_id"
  belongs_to :cohort, required: true, class_name: "Cohort", foreign_key: "cohort_id"

end
