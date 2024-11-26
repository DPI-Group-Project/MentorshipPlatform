class AddReferenceToCohortMembersOnUsers < ActiveRecord::Migration[7.2]
  def change
    add_foreign_key :users, :cohort_members, column: :email, primary_key: :email
  end
end
