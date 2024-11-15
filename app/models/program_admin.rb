# == Schema Information
#
# Table name: program_admins
#
#  id         :bigint           not null, primary key
#  email      :string           not null
#  program_id :bigint           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  role       :string
#
class ProgramAdmin < ApplicationRecord
  belongs_to :program, optional: false, class_name: "Program"
  belongs_to :admin, class_name: "User", foreign_key: "email", primary_key: "email", optional: true
end
