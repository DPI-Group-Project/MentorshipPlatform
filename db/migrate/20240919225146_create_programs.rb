class CreatePrograms < ActiveRecord::Migration[7.1]
  def change
    create_table :programs do |t|
      t.string :name
      t.text :description
      t.references :creator, null: false, foreign_key: { to_table: :users }
      t.references :contact, null: false, foreign_key: { to_table: :users }
      t.string :passcode

      t.timestamps
    end
  end
end
