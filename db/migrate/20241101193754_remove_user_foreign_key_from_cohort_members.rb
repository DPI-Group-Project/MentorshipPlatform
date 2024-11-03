class RemoveUserForeignKeyFromCohortMembers < ActiveRecord::Migration[7.1]
  def change
    remove_foreign_key :cohort_members, :users
  end
end
