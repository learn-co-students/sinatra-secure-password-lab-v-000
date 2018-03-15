class User < ActiveRecord::Base
  has_secure_password

  after_initialize :set_defaults

  def set_defaults
   self.balance ||= 0
  end

end
