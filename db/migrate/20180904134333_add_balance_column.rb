class AddBalanceColumn < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.column :balance, :float, default: false
    end
  end
end
