class AddShortlistStartAndEndTimeToCohort < ActiveRecord::Migration[7.1]
  def change
    add_column :cohorts, :shortlist_start_time, :datetime
    add_column :cohorts, :shortlist_end_time, :datetime
  end
end
