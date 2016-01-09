class User < ActiveRecord::Base
  has_secure_password #bcrypt
end
