class CreatePrograms < ActiveRecord::Migration[7.1]
  def change
    create_table :programs do |t|
      t.string :name
      t.text :description
      t.references :creator_id, null: false, foreign_key: { to_table: :users }
      t.references :contact_id, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
