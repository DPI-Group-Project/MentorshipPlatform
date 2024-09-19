class AddRequiredMeetingsToPrograms < ActiveRecord::Migration[7.1]
  def change
    add_column :programs, :required_meetings, :integer
  end
end
