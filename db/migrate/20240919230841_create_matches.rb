class CreateMatches < ActiveRecord::Migration[7.1]
  def change
    create_table :matches do |t|
      t.references :mentor, null: false, foreign_key: { to_table: :users }
      t.references :mentee, null: false, foreign_key: { to_table: :users }
      t.references :cohort, null: false, foreign_key: true
      t.boolean :active

      t.timestamps
    end
  end
end
