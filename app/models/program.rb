# == Schema Information
#
# Table name: programs
#
#  id                :bigint           not null, primary key
#  name              :string
#  description       :text
#  creator           :bigint           not null
#  contact           :bigint           not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  required_meetings :integer
#
class Program < ApplicationRecord
  belongs_to :creator, required: true, class_name: 'User', foreign_key: 'creator_id'
  has_many :cohorts, class_name: 'Cohort', foreign_key: 'program_id', dependent: :destroy
end
