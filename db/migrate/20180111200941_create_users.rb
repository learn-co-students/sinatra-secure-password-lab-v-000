class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |c|
      c.string :username
      c.string :password_digest
    end
  end
end
