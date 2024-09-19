class RemoveMatchesFromMatch < ActiveRecord::Migration[7.1]
  def change
    remove_column :matches, :matches
  end
end
