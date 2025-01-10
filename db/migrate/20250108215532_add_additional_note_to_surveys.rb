class AddAdditionalNoteToSurveys < ActiveRecord::Migration[7.2]
  def change
    add_column :surveys, :additional_note, :text
  end
end
