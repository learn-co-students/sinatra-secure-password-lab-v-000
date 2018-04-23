class CreateUser < ActiveRecord::Migration
  def change
    create_table :user do |t|
    t.string :username
    t.string :password
    t.integer :balance
  end
  end
end
