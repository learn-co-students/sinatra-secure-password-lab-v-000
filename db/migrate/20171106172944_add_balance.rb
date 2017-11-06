class AddBalance < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.decimal :balance
    end
  end
end
