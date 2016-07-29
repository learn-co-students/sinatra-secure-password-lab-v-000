# Change Password to Password Digest Class
class ChangePasswordToPasswordDigest < ActiveRecord::Migration
  def change
    rename_column :users, :password, :password_digest
  end
end
