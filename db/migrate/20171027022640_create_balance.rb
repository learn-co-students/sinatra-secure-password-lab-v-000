class CreateBalance < ActiveRecord::Migration
  def up
    add_column :users, :balance, :decimal
  end

  def down
    remove_column :users, :balance, :decimal
  end
end  #  End of Class
