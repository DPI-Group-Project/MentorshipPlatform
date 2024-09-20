# == Schema Information
#
# Table name: program_admins
#
#  id         :bigint           not null, primary key
#  user_id    :bigint           not null
#  program_id :bigint           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class ProgramAdmin < ApplicationRecord
  belongs_to :user_id
  belongs_to :program_id
end
