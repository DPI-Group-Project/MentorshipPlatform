class ChangeUserIdToEmailInCohortMember < ActiveRecord::Migration[7.1]
  def change
    rename_column(:cohort_members, :user_id, :email)
    remove_foreign_key(:cohort_members, column: :email)
    change_column(:cohort_members, :email, :string)
    add_foreign_key(:cohort_members, :users, column: :email, primary_key: :email)
  end
end
