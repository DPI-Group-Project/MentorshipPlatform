class CreateOrganizations < ActiveRecord::Migration[7.1]
  def change
    create_table :organizations do |t|
      t.references :user, null: false, foreign_key: { to_table: :users }
      t.references :program, null: false, foreign_key: { to_table: :programs }

      t.timestamps
    end
  end
end
