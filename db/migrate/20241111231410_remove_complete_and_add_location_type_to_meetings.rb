class RemoveCompleteAndAddLocationTypeToMeetings < ActiveRecord::Migration[7.1]
  def change
    remove_column :meetings, :complete, :boolean
    add_column :meetings, :location_type, :string
  end
end
