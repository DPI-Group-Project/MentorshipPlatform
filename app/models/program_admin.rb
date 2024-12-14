# == Schema Information
#
# Table name: program_admins
#
#  id                  :bigint           not null, primary key
#  user_id             :bigint           not null
#  program_id          :bigint           not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  created_by_admin_id :bigint
#
class ProgramAdmin < ApplicationRecord
  belongs_to :program, optional: false, class_name: "Program"
  belongs_to :admin, class_name: "User", foreign_key: "user_id", optional: true
end
