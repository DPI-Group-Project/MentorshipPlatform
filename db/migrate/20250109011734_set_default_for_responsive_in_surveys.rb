class SetDefaultForResponsiveInSurveys < ActiveRecord::Migration[7.2]
  def change
    change_column_default :surveys, :responsive, 0
  end
end
