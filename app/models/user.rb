class User < ActiveRecord::Base
  validates_presence_of :username, on: :create
  validates_presence_of :password, on: :create
  
  has_secure_password

  def self.input_valid?(params)
    params[:withdraw].to_i >= 0 && params[:deposit].to_i >= 0 
  end

  def self.update_balance(balance, params)
    balance += params[:deposit].to_i
    balance -= params[:withdraw].to_i
    ( balance < 0 ? false : balance )
  end
end