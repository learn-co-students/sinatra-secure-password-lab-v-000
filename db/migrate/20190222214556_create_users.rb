class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |table|
      table.string :username
      table.string :password 
    end
  end
end
