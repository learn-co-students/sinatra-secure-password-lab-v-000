class User < ActiveRecord::Base
    has_secure_password

  # def deposit(amount)
  #     self.balance += amount.to_f
  # end
  #
  # def withdraw(amount)
  #     self.balance = self.balance - amount.to_f
  # end

end
