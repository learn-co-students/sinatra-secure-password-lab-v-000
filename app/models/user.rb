class User < ActiveRecord::Base 
  has_secure_password
  validates :username, presence: true
  after_initialize :create_balance

  def create_balance
    self.balance = 0
  end  

end
