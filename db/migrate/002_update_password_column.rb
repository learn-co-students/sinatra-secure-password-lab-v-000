class UpdatePasswordColumn < ActiveRecord::Migration[5.0]
  def change
    rename_column :users, :password, :password_digest
  end
end
