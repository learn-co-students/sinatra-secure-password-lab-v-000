class AddingDefaultToBalance < ActiveRecord::Migration
  def change
    change_column_default(:users, :balance, 0.0)
  end
end
