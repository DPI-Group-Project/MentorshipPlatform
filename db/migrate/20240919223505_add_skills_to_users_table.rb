class AddSkillsToUsersTable < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :skills, :text, array: true, default: []
  end
end
