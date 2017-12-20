class ChangeBackPw < ActiveRecord::Migration[5.1]
  def change
    rename_column :users, :password, :password_digest
  end
end
