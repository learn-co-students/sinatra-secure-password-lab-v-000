class AddBalanceToUser < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.float :balance
    end
  end
end
