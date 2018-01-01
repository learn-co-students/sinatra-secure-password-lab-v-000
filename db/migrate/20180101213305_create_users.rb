class CreateUsers < ActiveRecord::Migration
  def change
        create_table :users do |u|
          u.string :username
          u.string :password_digest     #must be named password digest for bcrypt to work properly
        end
  end
end


#the following setup can be used as well, but rake db:rollback gives the same ability as the down instance method below

#class CreateUsers < ActiveRecord::Migration
#    def up
#        create_table :users do |t|
#            t.string :username
#            t.string :password_digest  #this is our encrypted password storage location which  will be mixed hashed and salted(adddition of extra characters randolmly)
#        end
#    end
#
#    def down
#        drop_table :users
#    end
#end
