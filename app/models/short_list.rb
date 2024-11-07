# == Schema Information
#
# Table name: short_lists
#
#  id         :bigint           not null, primary key
#  mentor_id  :bigint           not null
#  mentee_id  :bigint           not null
#  cohort_id  :bigint           not null
#  ranking     :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class ShortList < ApplicationRecord
  belongs_to :mentor, required: true, class_name: "User", foreign_key: "mentor_id"
  belongs_to :mentee, required: true, class_name: "User", foreign_key: "mentee_id"
  belongs_to :cohort, required: true, class_name: "Cohort", foreign_key: "cohort_id"
end
