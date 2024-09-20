class CreateReviews < ActiveRecord::Migration[7.1]
  def change
    create_table :reviews do |t|
      t.references :match, null: false, foreign_key: true
      t.string :responsive
      t.text :answer_if_other
      t.text :feedback
      t.integer :rating

      t.timestamps
    end
  end
end
