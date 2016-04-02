class AddBalanceToUsers < ActiveRecord::Migration
  def change
    add_column :users, :balance, :float, :precision => 8, :scale => 2
  end
end
