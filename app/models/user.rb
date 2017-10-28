class User < ActiveRecord::Base
  include ActiveRecord::Validations
  has_secure_password
  validates_presence_of :username
end
