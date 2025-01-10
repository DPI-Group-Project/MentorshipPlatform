class AddResponsiveReasonToSurveys < ActiveRecord::Migration[7.2]
  def change
    add_column :surveys, :responsive_reason, :text
  end
end
