class ChangeUsersBalanceColumn < ActiveRecord::Migration
  def change
    change_column :users, :balance, :string
  end
end
