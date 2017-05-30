class User < ActiveRecord::Base
  has_secure_password
  validates_presence_of :username
  validates_length_of :username, minimum: 1, too_short: 'Username cannot be blank'
  validates_uniqueness_of :username

  after_initialize :set_defaults

  def set_defaults
    self.balance ||= 0
  end
end
