class ChangeBalanceColumnOfUsers < ActiveRecord::Migration
  def change
    change_column :users, :balance, :decimal, precision: 10, scale: 2
  end
end
