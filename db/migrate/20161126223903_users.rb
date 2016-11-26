class Users < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.text :username
      t.text :password
    end
  end
end
