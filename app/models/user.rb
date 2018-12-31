class User < ActiveRecord::Base
  has_secure_password
  
  def inititalize(balance=0)
    @balance = balance
  end
  
  def display_balance
      @balance
  end
  
  def deposit(amount)
      @balance += amount
  end
  
  def withdraw(amount)
    if !amount > @balance
      @balance -= amount
    else
      raise.error 
    end
  end
end
