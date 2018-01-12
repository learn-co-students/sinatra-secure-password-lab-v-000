class ChangePasswordColumn < ActiveRecord::Migration

  def change
    rename_column :users, :passwords, :password_digest
  end

end
