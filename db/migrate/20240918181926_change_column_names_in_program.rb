class ChangeColumnNamesInProgram < ActiveRecord::Migration[7.1]
  def change
    rename_column :programs, :creator_id_id, :creator
    rename_column :programs, :contact_id_id, :contact
  end
end
