class User < ActiveRecord::Base
  has_secure_password
  validates :username, uniqueness: true

    def deposit(amount)
      self.balance += convert(amount)
      self.save
    end 

    def withdraw(amount)
      if amount <= self.balance.to_s
        self.balance -= convert(amount) 
        self.save
      else
        "Insufficient Funds."
      end 
    end 

    def convert(amount) 
      amount = BigDecimal.new(amount.gsub(",",""))
    end 
end
