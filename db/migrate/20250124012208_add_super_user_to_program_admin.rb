class AddSuperUserToProgramAdmin < ActiveRecord::Migration[7.2]
  def change
    add_column :program_admins, :super_user, :boolean, default: false, null: false
  end
end
