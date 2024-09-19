class CreateMatches < ActiveRecord::Migration[7.1]
  def change
    create_table :matches do |t|
      t.string :matches
      t.references :mentor_id, null: false, foreign_key: true
      t.references :mentee_id, null: false, foreign_key: true
      t.references :cohort_id, null: false, foreign_key: true
      t.boolean :active

      t.timestamps
    end
  end
end
