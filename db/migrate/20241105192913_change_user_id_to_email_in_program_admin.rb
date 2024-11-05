class ChangeUserIdToEmailInProgramAdmin < ActiveRecord::Migration[7.1]
  def change
    rename_column(:program_admins, :user_id, :email)
    remove_foreign_key(:program_admins, column: :email)
    change_column(:program_admins, :email, :string)
    add_foreign_key(:program_admins, :users, column: :email, primary_key: :email)
  end
end
