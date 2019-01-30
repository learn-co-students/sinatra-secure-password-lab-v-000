class CreateUsers < ActiveRecord::Migration
  
  def change
    create_table :users do |t|
      t.string :username
      # t.string :password # don't need to add this if adding password_digest column
      # password_digest is needed with has_secure_password inside user.rb
      t.string :password_digest
    end
  end
  
end