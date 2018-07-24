#require 'bcrypt'

class User < ActiveRecord::Base
  has_secure_password
  # users.password_hash in the database is a :string
  #include BCrypt

#  def password
#    @password ||= Password.new(password_hash)
#  end

#  def password=(new_password)
  #  binding.pry
#    @password = Password.create(new_password)
#    self.password_digest = @password
#  end
end
