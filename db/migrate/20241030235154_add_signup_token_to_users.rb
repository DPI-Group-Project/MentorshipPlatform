class AddSignupTokenToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :signup_token, :string
    add_index :users, :signup_token, unique: true
    
  end
end
