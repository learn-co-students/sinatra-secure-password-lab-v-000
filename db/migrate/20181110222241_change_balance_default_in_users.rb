class ChangeBalanceDefaultInUsers < ActiveRecord::Migration[5.1]
  def change
    change_column_default :users, :balance, 0
  end
end
