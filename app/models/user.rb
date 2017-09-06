class User < ActiveRecord::Base
  has_secure_password

  validates :username, :password_digest, presence: :true

  def deposit(amount)
    self.balance += amount
    self.save
    "Your deposit was a success! You are now $#{amount} wealthier!"
  end

  def withdrawal(amount)
    if self.balance > amount
      self.balance -= amount
      self.save
      "You have withdrawn $#{amount}. Your current balance is $#{self.amount} Don't spend it all at once!"
    else
      "You don't have enough monies! This transaction cannot be completed."
    end
  end
end
