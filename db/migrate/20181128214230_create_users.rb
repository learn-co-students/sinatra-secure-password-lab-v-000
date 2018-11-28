class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |i|
      i.string :username
      i.string :password_digest
    end
  end
end
