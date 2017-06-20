class User < ActiveRecord::Base

  has_secure_password

  # validates_presence_of :username, :password

  after_initialize :init

  def init
    self.balance ||= 0.00
  end

end
