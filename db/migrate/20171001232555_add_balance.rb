class AddBalance < ActiveRecord::Migration
  def change
    add_column :users, :balance, :float, :scale => 2, :precision => 2, :default => 0.00
  end
end
