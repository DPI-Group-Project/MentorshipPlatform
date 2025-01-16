class ChangeResponsiveToNotNullInSurveys < ActiveRecord::Migration[7.2]
  def change
    change_column_null :surveys, :responsive, false
  end
end
