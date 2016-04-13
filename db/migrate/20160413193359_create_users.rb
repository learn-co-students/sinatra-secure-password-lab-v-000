class CreateUsers < ActiveRecord::Migration
  def change

    create_table :users do |t|
      t.string :username
      t.string :password
      t.float :balance, default: 0.00
    end
  end
end
