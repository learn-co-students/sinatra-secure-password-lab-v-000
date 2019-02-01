class CreateUsers < ActiveRecord::Migration
  def change
    create_table :Users do |t|
      t.string :username
      t.string :password
    end
  end
end
