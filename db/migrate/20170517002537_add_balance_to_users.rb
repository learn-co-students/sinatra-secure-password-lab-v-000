class AddBalanceToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :balance, :decimal, default: 0.0
  end
end
