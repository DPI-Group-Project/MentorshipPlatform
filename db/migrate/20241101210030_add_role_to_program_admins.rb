class AddRoleToProgramAdmins < ActiveRecord::Migration[7.1]
  def change
    add_column :program_admins, :role, :string
  end
end
