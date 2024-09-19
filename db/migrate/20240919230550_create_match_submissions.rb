class CreateMatchSubmissions < ActiveRecord::Migration[7.1]
  def change
    create_table :match_submissions do |t|
      t.references :mentor_id, null: false, foreign_key: { to_table: :users }
      t.references :mentee_id, null: false, foreign_key: { to_table: :users }
      t.integer :ranking

      t.timestamps
    end
  end
end
