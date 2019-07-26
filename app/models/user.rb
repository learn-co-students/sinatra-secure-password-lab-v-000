class User < ActiveRecord::Base
  has_secure_password
  
  #def initialize
  #  @balance ||= 0
  #end
end
