class CreateProgramAdmins < ActiveRecord::Migration[7.1]
  def change
    create_table :program_admins do |t|
      t.references :user, null: false, foreign_key: true
      t.references :program, null: false, foreign_key: true

      t.timestamps
    end
  end
end
