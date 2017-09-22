class AddBalanceToUsers < ActiveRecord::Migration[5.1]
  def change
    # adds a default value of 0 to all accounts
    add_column :users, :balance, :real, :default => 0
  end
end
