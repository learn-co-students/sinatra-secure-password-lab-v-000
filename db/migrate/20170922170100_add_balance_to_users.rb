class AddBalanceToUsers < ActiveRecord::Migration
  def change
    #add balance column, starts at zero for new users
    add_column :users, :balance, :integer, :default => 0
  end
end
