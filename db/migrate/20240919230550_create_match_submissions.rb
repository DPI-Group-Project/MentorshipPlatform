class CreateMatchSubmissions < ActiveRecord::Migration[7.1]
  def change
    create_table :match_submissions do |t|
      t.references :mentor, null: false, foreign_key: { to_table: :users }
      t.references :mentee, null: false, foreign_key: { to_table: :users }
      t.integer :ranking

      t.timestamps
    end
  end
end
