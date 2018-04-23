class RenameUsers < ActiveRecord::Migration
  def change
    rename_table :user, :users

  end
end
