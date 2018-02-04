class User < ActiveRecord::Base
  has_secure_password
  validates :username, :presence => true

  after_initialize :init

  def init
    self.balance ||= 0.00
  end

  def deposit(amount)
    balance + amount.to_i
  end

  def withdraw(amount)
    balance - amount.to_i
  end
    
  
end
