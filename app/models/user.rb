class User < ActiveRecord::Base
  has_secure_password

  def balance_to_currency
    #binding.pry
    "$#{self.balance.to_i}."+"#{(self.balance % 1.0)}"[2..3]
  end
end
