class CreateSurveys < ActiveRecord::Migration[7.1]
  def change
    create_table :surveys do |t|
      t.integer :match_id
      t.boolean :responsive
      t.string :answer_if_other
      t.text :body
      t.integer :rating

      t.timestamps
    end
  end
end
