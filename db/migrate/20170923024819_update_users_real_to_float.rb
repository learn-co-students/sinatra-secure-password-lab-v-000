class UpdateUsersRealToFloat < ActiveRecord::Migration[5.1]
  def change
    change_column :users, :balance, :float, :default => 0
  end
end
