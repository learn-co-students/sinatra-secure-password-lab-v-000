class User < ActiveRecord::Base
	has_secure_password
	validates_presence_of :username, :password_digest

	def deposit(amount)
		self.balance += amount
	end

	def withdrawal(amount)
		self.balance -= amount unless self.balance < amount
	end

end

