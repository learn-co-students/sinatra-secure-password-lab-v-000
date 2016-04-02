class AddBalanceColumnWithDefault < ActiveRecord::Migration
  def change
    add_column :users, :balance, :float, :default => 0, :precision => 8, :scale => 2
  end
end
