class AddCreatedByAdminIdToProgramAdmins < ActiveRecord::Migration[7.2]
  def change
    add_column :program_admins, :created_by_admin_id, :bigint
    add_foreign_key :program_admins, :users, column: :created_by_admin_id
  end
end
