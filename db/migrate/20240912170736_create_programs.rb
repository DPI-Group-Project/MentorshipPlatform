class CreatePrograms < ActiveRecord::Migration[7.1]
  def change
    create_table :programs do |t|
      t.string :name
      t.text :description
      t.integer :creator_id
      t.integer :contact_id

      t.timestamps
    end
  end
end
