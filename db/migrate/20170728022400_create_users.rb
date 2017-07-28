class CreateUsers < ActiveRecord::Migration
  def up
    create_table :users do |user|
      user.string :username
      user.string :password_digest
    end
  end

  def down
    drop_table :users
  end
end
