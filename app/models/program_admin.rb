# == Schema Information
#
# Table name: program_admins
#
#  id         :bigint           not null, primary key
#  email      :string           not null
#  program_id :bigint           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class ProgramAdmin < ApplicationRecord
  belongs_to :program, required: true, class_name: 'Program', foreign_key: 'program_id'
  has_one :admin, class_name: 'User', primary_key: 'email', foreign_key: 'email'
end
