require 'pry'
class User < ActiveRecord::Base
  
  has_secure_password
end
