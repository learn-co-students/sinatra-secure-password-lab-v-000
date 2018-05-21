class CreateUser < ActiveRecord::Migration[5.1]

  # create a table using the Rake T.... under activerecord sinatra.
    def up
        create_table :users do |t|
            t.string :username
            t.string :password_digest
        end
    end

    def down
        drop_table :users
    end
end
