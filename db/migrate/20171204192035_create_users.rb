class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |col|
      col.text :username
      col.text :password_digest
    end
  end
end
