class ChangeCreatorIdToReferenceInPrograms < ActiveRecord::Migration[7.1]
  def change
    remove_column :programs, :creator_id, :integer

    add_reference :programs, :creator_id, foreign_key: { to_table: :users }
  end
end
