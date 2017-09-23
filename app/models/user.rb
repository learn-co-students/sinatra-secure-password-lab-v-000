require 'pry'
class User < ActiveRecord::Base
  has_secure_password

  def deposit(depo)
    self.balance += depo
    self.save
  end

  def withdrawal(remove)
    self.balance -= remove
    self.save
  end
end