# == Schema Information
#
# Table name: programs
#
#  id          :bigint           not null, primary key
#  name        :string
#  description :text
#  creator_id  :bigint           not null
#  contact_id  :bigint           not null
#  passcode    :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Program < ApplicationRecord
  belongs_to :creator, required: true, class_name: "User", foreign_key: "creator_id"
  belongs_to :contact, required: true, class_name: "User", foreign_key: "contact_id"
  has_many :cohorts, class_name: "Cohort", foreign_key: "program_id", dependent: :destroy
  has_many :admins, class_name: "ProgramAdmin", foreign_key: "program_id", dependent: :destroy
end
