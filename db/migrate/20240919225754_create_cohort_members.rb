class CreateCohortMembers < ActiveRecord::Migration[7.1]
  def change
    create_table :cohort_members do |t|
      t.references :user_id, null: false, foreign_key: true
      t.references :cohort_id, null: false, foreign_key: true
      t.string :role

      t.timestamps
    end
  end
end
