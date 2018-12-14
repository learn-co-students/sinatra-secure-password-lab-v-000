class AddBalanceToUsers < ActiveRecord::Migration
  def change
    # wouldn't want to use float in a real-world situation; can cause errors in arithmetic
    add_column :users, :balance, :float, :default => 0
  end
end
