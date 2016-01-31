class CreateUsersTable < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username
      t.string :password_digest
      t.decimal :balance, precision: 10, scale: 2
    end
  end
end
