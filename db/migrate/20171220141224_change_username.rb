class ChangeUsername < ActiveRecord::Migration[5.1]
  def change
    rename_column :users, :name, :username 
  end
end
