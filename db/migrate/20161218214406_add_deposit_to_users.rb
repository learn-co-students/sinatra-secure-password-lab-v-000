class AddDepositToUsers < ActiveRecord::Migration
  def change
    add_column :users, :deposit, :decimal
  end  
end
