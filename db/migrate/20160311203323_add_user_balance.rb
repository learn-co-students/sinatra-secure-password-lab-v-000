class AddUserBalance < ActiveRecord::Migration
  def change
    add_column :users, :balance, :decimal, {default: 0, precision: 2}
  end
end
