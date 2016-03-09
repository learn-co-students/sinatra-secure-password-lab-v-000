class AddBalanceToUsers < ActiveRecord::Migration
  def change
    add_column :users, :balance, :float
    change_column_default :users, :balance, 0.0
  end
end
