class Balance < ActiveRecord::Migration[5.1]
  def change
    change_table :users do |t|
      t.integer :balance, :default => 0
    end
  end
end
