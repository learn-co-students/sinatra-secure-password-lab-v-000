class User < ActiveRecord::Base
  has_secure_password
  validates :username, :balance, presence: true
end
