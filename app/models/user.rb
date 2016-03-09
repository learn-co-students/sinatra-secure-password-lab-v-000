class User < ActiveRecord::Base
  validates :username, presence: true

  has_secure_password

  def deposit(num)
    self.balance = num
  end

  def withdraw(num)
    self.balance -= num
  end
end
