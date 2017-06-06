class User < ActiveRecord::Base
  has_secure_password
  validates :username, presence: true, on: :create
  validates :password, presence: true, on: :create
end
