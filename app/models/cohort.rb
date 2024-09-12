# == Schema Information
#
# Table name: cohorts
#
#  id          :bigint           not null, primary key
#  program_id  :integer
#  cohort_name :string
#  description :text
#  start_date  :datetime
#  end_date    :datetime
#  creator_id  :integer
#  contact_id  :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Cohort < ApplicationRecord
  belongs_to :creator, required: true, class_name: 'User', foreign_key: 'creator_id'
  belongs_to :program, required: true, class_name: 'Program', foreign_key: 'program_id'
end
