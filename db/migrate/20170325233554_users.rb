class Users < ActiveRecord::Migration
  def change
    create_table :users do | f |
      f.string :username
      f.string :password_digest
    end
  end
end
