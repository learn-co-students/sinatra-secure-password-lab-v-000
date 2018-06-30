class User < ActiveRecord::Base
  has_secure_password # ruby macro that interacts with bcrypt and stores secure passwords.
end
