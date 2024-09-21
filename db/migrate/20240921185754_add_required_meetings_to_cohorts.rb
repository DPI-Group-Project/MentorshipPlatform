class AddRequiredMeetingsToCohorts < ActiveRecord::Migration[7.1]
  def change
    add_column :cohorts, :required_meetings, :integer
  end
end
