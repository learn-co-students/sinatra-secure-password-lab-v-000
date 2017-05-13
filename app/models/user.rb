class User < ActiveRecord::Base
  has_secure_password

  def self.build(params)
    user = User.new(params)
    user.balance = 0
    user
  end

  def withdrawal(amount)
    self.balance -= amount
    self.save
  end

  def deposit(amount)
    self.balance += amount
    self.save
  end
end
