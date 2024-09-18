class RenameColumnsInCohorts < ActiveRecord::Migration[7.1]
  def change
    rename_column :cohorts, :program_id_id, :program
    rename_column :cohorts, :creator_id_id, :creator
    rename_column :cohorts, :contact_id_id, :contact
  end
end
