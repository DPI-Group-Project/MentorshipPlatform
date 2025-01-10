class ChangeResponsiveToNotNullInSurveys < ActiveRecord::Migration[7.2]
  def change
    change_column_null :surveys, :responsive, null: false, default: 0
  end
end
