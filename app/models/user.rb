class User < ActiveRecord::Base
  	has_secure_password #is a macro provided by bcrypt that creates methods for us to be used
end
