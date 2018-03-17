# User model
class User < ActiveRecord::Base
  has_secure_password
  validates_presence_of :username
  validates :username, length: { minimum: 1 }
end
