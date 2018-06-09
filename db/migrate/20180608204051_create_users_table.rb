class CreateUsersTable < ActiveRecord::Migration[5.2]

  def change
    create_table :users do |t|
      t.string :username
      t.string :password
    end #create_table
  end #change

end
