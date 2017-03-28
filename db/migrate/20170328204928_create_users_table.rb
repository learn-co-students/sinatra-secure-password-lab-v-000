class CreateUsersTable < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username, :length => { :minimum => 2 }
      t.string :password_digest, presence: true
    end
  end
end
