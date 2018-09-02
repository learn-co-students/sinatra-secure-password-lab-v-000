class Users < ActiveRecord::Migration
  def change
    create_table Users do |t|
      t.string :username
      t.string :password_digest
    end
  end
end
