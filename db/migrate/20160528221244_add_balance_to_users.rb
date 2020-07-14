class AddBalanceToUsers < ActiveRecord::Migration
  def up
    add_column :users, :balance, :float, :default => 0.0
  end

  def down
    remove_column :users, :balance
  end
end
