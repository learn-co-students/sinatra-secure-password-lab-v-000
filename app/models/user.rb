class User < ActiveRecord::Base
  has_secure_password
  validates_presence_of :username, :password

  def deposit(amt)
    balance = balance + amt
  end

  def withdrawl(amt)
    balance = balance - amt
  end

end
