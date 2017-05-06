class User < ActiveRecord::Base

  has_secure_password

  validates :username, :password_digest, presence: true

  def deposit(amount)
    self.balance += amount
    self.save
    "Your transaction is successful. Your current balance is #{self.balance}"
  end

  def withdrawal(amount)
    # binding.pry
    if self.balance >= amount
      self.balance -= amount
      self.save
      "Your transaction is successful. Your current balance is #{self.balance}"
    else
      "This transaction can't be completed."
    end
  end
end
