class User < ActiveRecord::Base

	has_secure_password
	validates :username, presence: true, allow_blank: false
	
end
