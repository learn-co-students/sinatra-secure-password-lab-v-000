class RenamePasswordColumn < ActiveRecord::Migration
  def change
    rename_column :users, :password, :passwor_digest
  end
end
