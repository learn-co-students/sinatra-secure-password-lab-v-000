class AddBalance < ActiveRecord::Migration
  def change
    add_column :users, :balance, :decimal, :precision => 12, :scale => 2
  end
end
