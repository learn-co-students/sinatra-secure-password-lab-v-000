class ChangeIntegerLimitInAcct < ActiveRecord::Migration
  def change
  change_column :users, :acct_num, :integer, limit: 10
  end
end
