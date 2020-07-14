class AddBalance < ActiveRecord::Migration
  def change
    add_column :users, :balance, :float, :default => 0.00  
  end
end
