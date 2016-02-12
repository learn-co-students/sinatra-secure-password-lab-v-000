class AddBalanceToUsers < ActiveRecord::Migration
  def up
    change_table :users do |t|
      t.float :balance, :default => "0"
    end
  end

  def down
    remove_column :users, :balance
  end
end
