class CreateUsers < ActiveRecord::Migration
    def change
        create_table :users do |t|
            t.string :email
            t.string :password_diget
        end
    end
end
