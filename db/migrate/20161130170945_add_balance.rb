class AddBalance < ActiveRecord::Migration
  def change
    add_column(:users, :balance, :Integer)
  end
end
