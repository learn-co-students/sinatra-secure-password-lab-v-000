class User < ActiveRecord::Base
    validates :username, :password, length: {minimum: 1}
    has_secure_password
end
