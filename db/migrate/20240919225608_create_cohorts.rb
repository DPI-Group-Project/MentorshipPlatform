class CreateCohorts < ActiveRecord::Migration[7.1]
  def change
    create_table :cohorts do |t|
      t.references :program, null: false, foreign_key: true
      t.string :cohort_name
      t.text :description
      t.datetime :start_date
      t.datetime :end_date
      t.references :creator, null: false, foreign_key: { to_table: :users }
      t.references :contact, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
