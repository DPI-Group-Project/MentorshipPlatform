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
end
