class RemovePasswordAddBcrypt < ActiveRecord::Migration
  def change
    remove_column :users, :password

    add_column :users, :password_digest, :string, default: 0.00
  end
end
