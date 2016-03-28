class AddBalanceColumn < ActiveRecord::Migration
  def change
    add_column :users, :balance, :decimal, :precision => 8, :scale =>2
  end
end
