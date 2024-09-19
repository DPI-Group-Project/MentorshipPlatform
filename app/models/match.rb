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
  belongs_to :mentor_id
  belongs_to :mentee_id
  belongs_to :cohort_id
end
