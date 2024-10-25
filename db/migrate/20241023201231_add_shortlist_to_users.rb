class AddShortlistToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :shortlist, :jsonb, array: true, default: []
  end
end
