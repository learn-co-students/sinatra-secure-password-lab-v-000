class ChangeBalanceDefaultAgainInUsers < ActiveRecord::Migration
  def change
    change_column_default(:users, :balance, 0.00)
  end
end
