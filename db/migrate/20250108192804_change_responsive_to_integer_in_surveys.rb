class ChangeResponsiveToIntegerInSurveys < ActiveRecord::Migration[7.2]
  def change
    change_column :surveys, :responsive, :integer, using: 'responsive::integer'
  end
end
