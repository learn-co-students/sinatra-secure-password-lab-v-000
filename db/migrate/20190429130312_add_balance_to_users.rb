class AddBalanceToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :balance, :integer
  end
end
