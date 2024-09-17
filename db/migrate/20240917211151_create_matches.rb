class CreateMatches < ActiveRecord::Migration[7.1]
  def change
    create_table :matches do |t|
      t.integer :mentor_id
      t.integer :mentee_id
      t.integer :cohort_id
      t.boolean :active

      t.timestamps
    end
  end
end
