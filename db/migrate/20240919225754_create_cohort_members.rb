class CreateCohortMembers < ActiveRecord::Migration[7.1]
  def change
    create_enum :role, %w[mentor mentee]

    create_table :cohort_members, id: false do |t|
      t.string :email, null: false, primary_key: true
      t.references :cohort, null: false, foreign_key: true
      t.enum :role, enum_type: :role
      t.integer :capacity
      t.timestamps
    end

    add_index :cohort_members, :email, unique: true
  end
end
