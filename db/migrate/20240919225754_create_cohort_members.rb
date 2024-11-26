class CreateCohortMembers < ActiveRecord::Migration[7.1]
  def change
    create_enum :role, %w[mentor mentee]

    create_table :cohort_members, id: false, primary_key: :email do |t|
      t.references :cohort, null: false, foreign_key: true
      t.string :email, null: false
      t.enum :role, enum_type: :role
      t.integer :capacity
      t.timestamps

      t.index ["email"], unique: true
    end
  end
end
