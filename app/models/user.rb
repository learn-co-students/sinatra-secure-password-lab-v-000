class User < ActiveRecord::Base
  include ActiveModel::Validations

  has_secure_password

  validates_presence_of :username

  alias original_initialize initialize
  def initialize(params)
    original_initialize(params)
    self.balance = 0
  end
end
