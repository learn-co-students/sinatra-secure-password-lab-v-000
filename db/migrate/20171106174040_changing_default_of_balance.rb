class ChangingDefaultOfBalance < ActiveRecord::Migration
  def change
    change_column_default(:users, :balance, 0)
  end
end
