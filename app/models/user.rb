class User < ActiveRecord::Base
  has_secure_password
  validates_presence_of :username, :password
  # attr_accessor :balance
  # def initialize(params)
  #   @balance = 0
  # end
end
