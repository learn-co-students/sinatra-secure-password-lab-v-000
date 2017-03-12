class CreateUser < ActiveRecord::Migration
  def change
    create_table :users do |u|
      u.string :name
      u.string :password_digest
    end
  end
end
