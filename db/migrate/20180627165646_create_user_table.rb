class CreateUserTable < ActiveRecord::Migration
  def change
    create_table :user do |t|
      t.string :username
      t.string :password
    end
  end
end
