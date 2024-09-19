class ProgramAdmin < ApplicationRecord
  belongs_to :user_id
  belongs_to :program_id
end
