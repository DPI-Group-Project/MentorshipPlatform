# == Schema Information
#
# Table name: programs
#
#  id          :bigint           not null, primary key
#  name        :string
#  description :text
#  contact_id  :bigint           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Program < ApplicationRecord
  belongs_to :contact, optional: false, class_name: "User"
  has_many :cohorts, class_name: "Cohort", dependent: :destroy
  has_many :admins, class_name: "ProgramAdmin", dependent: :destroy
end
