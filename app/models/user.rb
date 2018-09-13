class User < ActiveRecord::Base
  validates :name, presence: true
  validates :password, presence: true
  has_secure_password
end
