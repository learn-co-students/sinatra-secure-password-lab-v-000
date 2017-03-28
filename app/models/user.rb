class User < ActiveRecord::Base
  has_secure_password
  validates :username, :length => { :minimum => 2 }
end
