class CreateMatches < ActiveRecord::Migration[7.1]
  def change
    create_table :matches do |t|
      t.references :mentor, foreign_key: { to_table: :users }
      t.references :mentee, foreign_key: { to_table: :users }
      t.references :cohort, null: false, foreign_key: {to_table: :cohorts}
      t.boolean :active

      t.timestamps
    end
  end
end
