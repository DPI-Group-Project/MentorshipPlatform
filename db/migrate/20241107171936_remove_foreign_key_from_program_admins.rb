class RemoveForeignKeyFromProgramAdmins < ActiveRecord::Migration[7.1]
  def change
    remove_foreign_key :program_admins, column: :email
  end
end
