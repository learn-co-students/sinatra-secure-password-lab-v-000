class AddUserBalance < ActiveRecord::Migration
  def change
    add_column :users, :balance, :decimal
  end
end
