# require 'money'
class User < ActiveRecord::Base

  has_secure_password
  # attr_accessor :balance
  # attr_reader :username, :password
  #
  # def initialize(params)
  #   @username = params[:username]
  #   @password = params[:password]
  #   @balance = Money.new(0, "USD")
  # end
  #
  # def deposit(amount)
  #   balance += Money.new(amount, "USD")
  # end
  #
  # def withdraw(amount)
  #   if  Money.new(amount, "USD") <= balance
  #     balance -= Money.new(amount, "USD")
  #   else
  #     withdraw(amount)
  #   end
  # end

end
