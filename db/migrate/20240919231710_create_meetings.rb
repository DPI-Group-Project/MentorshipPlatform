class CreateMeetings < ActiveRecord::Migration[7.1]
  def change
    create_table :meetings do |t|
      t.references :match, null: false, foreign_key: true
      t.boolean :complete
      t.date :date
      t.time :time
      t.text :notes
      t.string :location

      t.timestamps
    end
  end
end
