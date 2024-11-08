class UpdateMeetingsTable < ActiveRecord::Migration[7.1]
  def change
    remove_column :meetings, :time, :datetime
    
    # Adding date and time columns separately
    add_column :meetings, :date, :date
    add_column :meetings, :time, :time

    # Remove review_id column
    remove_column :meetings, :review_id, :bigint

    # Add new notes and location columns
    add_column :meetings, :notes, :text
    add_column :meetings, :location, :string
  end
end
