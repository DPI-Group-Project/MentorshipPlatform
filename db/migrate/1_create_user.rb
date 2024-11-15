class CreateUser < ActiveRecord::Migration[7.1]
  def change
    create_table :users, &:timestamps
  end
end
