class Createusers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username
      t.string :password_digest
      t.integer :balance
      t.integer :acct_num
    end
  end
end
