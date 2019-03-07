class User < ActiveRecord::Base
    has_secure_password
    validates_presence_of :username

    def withdrawl(amount)
        amount = Integer(amount)
        new_balance = self.balance - amount
        if new_balance >= 0
            self.balance -= amount
            self.save
            self.balance
        else
            nil
        end
    end

    def deposit(amount)
        amount = Integer(amount)
        self.balance += amount
        self.save
        self.balance
    end
end
