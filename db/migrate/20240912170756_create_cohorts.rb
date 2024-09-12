class CreateCohorts < ActiveRecord::Migration[7.1]
  def change
    create_table :cohorts do |t|
      t.integer :program_id
      t.string :cohort_name
      t.text :description
      t.datetime :start_date
      t.datetime :end_date
      t.integer :creator_id
      t.integer :contact_id

      t.timestamps
    end
  end
end
