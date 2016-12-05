class Users < ActiveRecord::Migration
  def up
    create_table :users do |x|
        x.string :username
        x.string :password_digest
    end
  end

  def down
    drop_table :users
  end
end
