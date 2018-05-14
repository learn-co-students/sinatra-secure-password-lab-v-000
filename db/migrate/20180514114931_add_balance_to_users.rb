class AddBalanceToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :balance, :integer, default: 0
  end
end
