class CreateShortLists < ActiveRecord::Migration[7.1]
  def change
    create_table :short_lists do |t|
      t.references :mentor, null: false, foreign_key: { to_table: :users }
      t.references :mentee, null: false, foreign_key: { to_table: :users }
      t.references :cohort, null: false, foreign_key: true
      t.integer :ranking

      t.timestamps
    end
  end
end
