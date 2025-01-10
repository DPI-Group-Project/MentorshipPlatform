class AddExperienceReasonToSurveys < ActiveRecord::Migration[7.2]
  def change
    add_column :surveys, :experience_reason, :text
  end
end
