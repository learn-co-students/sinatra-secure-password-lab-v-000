class User < ActiveRecord::Base

	has_secure_password
	validates :username, :presence => true


	def deposit(amount)
		self.balance += amount.to_i
	end

	def withdrawal(amount)
		self.balance -= amount.to_i
	end

end
