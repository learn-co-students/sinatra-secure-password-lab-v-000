# class User < ActiveRecord::Base
  
#   has_secure_password
# end
require 'bcrypt'

class User < ActiveRecord::Base
  has_secure_password

  # my_password = BCrypt::Password.create("my password")
end