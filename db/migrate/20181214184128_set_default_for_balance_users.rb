class SetDefaultForBalanceUsers < ActiveRecord::Migration
  def change
      change_column(:users, :balance, :integer, :default => 0)
    end
end
