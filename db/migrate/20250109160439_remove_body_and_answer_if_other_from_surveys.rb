class RemoveBodyAndAnswerIfOtherFromSurveys < ActiveRecord::Migration[7.2]
  def change
    remove_column :surveys, :body
    remove_column :surveys, :answer_if_other
  end
end
