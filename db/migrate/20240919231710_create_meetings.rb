class CreateMeetings < ActiveRecord::Migration[7.1]
  def change
    create_table :meetings do |t|
      t.references :match, null: false, foreign_key: true
      t.datetime :time
      t.boolean :complete
      t.references :review, null: false, foreign_key: true

      t.timestamps
    end
  end
end
