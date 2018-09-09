class User < ActiveRecord::Base
  has_secure_password

  validates :username, :presence => true

  def deposit(amount)
    self.balance += amount.to_i
    self.save
  end

  def withdrawl(amount)
    self.balance -= amount.to_i if self.balance > amount.to_i
    self.save
  end
end
