class User < ActiveRecord::Base
  has_secure_password #remember this password macro
end
