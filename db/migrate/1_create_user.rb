class CreateUser < ActiveRecord::Migration[7.1]
  def change
    create_enum :status, %w[active inactive archived]
    create_table :users, &:timestamps
  end
end
