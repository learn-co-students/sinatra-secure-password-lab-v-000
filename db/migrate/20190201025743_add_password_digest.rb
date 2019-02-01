class AddPasswordDigest < ActiveRecord::Migration
  def change
    add_column :Users, :password_digest, :string
  end
end
