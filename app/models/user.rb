class User < ActiveRecord::Base
  has_secure_password

  def self.make_deposit(user, amount)
    user.balance += amount
    user.save
  end

  def self.make_withdrawal(user, amount)
    if user.balance < amount
      false
    else
      user.balance -= amount
      user.save
    end
  end 
end
