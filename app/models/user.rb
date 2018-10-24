class User < ActiveRecord::Base
  has_secure_password

  def initialize(hash)
    super
    self.balance = 0
  end

end
