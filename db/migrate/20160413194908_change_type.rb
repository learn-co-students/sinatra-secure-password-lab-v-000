class ChangeType < ActiveRecord::Migration
  def change

    remove_column :users, :password_digest

    add_column :users, :password_digest, :float, default: 0.00
  end
end
