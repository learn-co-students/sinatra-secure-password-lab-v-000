class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t| #pass name of table we want to create as a symbol
        t.string :username
        t.string :password_digest
    end

  end
end
