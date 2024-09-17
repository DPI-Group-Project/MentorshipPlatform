class CreateReviews < ActiveRecord::Migration[7.1]
  def change
    create_table :reviews do |t|
      t.references :match_id, null: false, foreign_key: true
      t.string :responsive
      t.text :body
      t.integer :rating

      t.timestamps
    end
  end
end
