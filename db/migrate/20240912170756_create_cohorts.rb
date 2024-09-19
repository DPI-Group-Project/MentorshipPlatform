class CreateCohorts < ActiveRecord::Migration[7.1]
  def change
    create_table :cohorts do |t|
      t.references :program_id, null: false, foreign_key: { to_table: :programs }
      t.string :cohort_name
      t.text :description
      t.datetime :start_date
      t.datetime :end_date
      t.references :creator_id, null: false, foreign_key: { to_table: :users }
      t.references :contact_id, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
