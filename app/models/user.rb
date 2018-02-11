class User < ActiveRecord::Base

	has_secure_password
	validates :username, :presence => true


	def deposit(amount)
		balance = self.balance.to_i
		transaction_balance = balance += (amount.to_i)
		self.balance = sprintf("%.2f", transaction_balance)
		#still not displaying decimals correctly 
	end

	def withdrawal(amount)
		balance = self.balance.to_i
		balance -= (amount.to_i)
		self.balance = balance
	end

end
