class User < ActiveRecord::Base
  validates :username, presence: true

  has_secure_password

  def deposit(amount)
    if amount > 0
      update(balance: balance + amount)
    end
  end

  def withdrawal(amount)
    if balance >= amount
      update(balance: balance - amount)
    end
  end
end
