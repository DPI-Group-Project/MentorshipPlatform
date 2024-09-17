class ChangeContactIdToReferenceInPrograms < ActiveRecord::Migration[7.1]
  def change
    remove_column :programs, :contact_id, :integer

    add_reference :programs, :contact_id, foreign_key: { to_table: :users }
  end
end
