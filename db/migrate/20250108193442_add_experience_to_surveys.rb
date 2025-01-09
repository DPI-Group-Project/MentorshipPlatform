class AddExperienceToSurveys < ActiveRecord::Migration[7.2]
  def change
    add_column :surveys, :experience, :integer, null: false, default: 0
  end
end
