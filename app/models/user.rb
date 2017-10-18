class User < ActiveRecord::Base
  has_secure_password
  attr_reader :balance, :transactions

  def balance_account
    @balance = 0.0
    @transactions.each do |transaction|
    balance += transaction[:amount]
    end
    balance
  end
end
