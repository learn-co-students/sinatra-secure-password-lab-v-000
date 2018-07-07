class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |u|
      u.string :username
      u.string :password_digest
    end
  end
end
