class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.text :username
      t.integer :balance, :default => '0' 
      t.text :password_digest
    end
  end
end
