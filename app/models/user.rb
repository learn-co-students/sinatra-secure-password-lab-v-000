class User < ActiveRecord::Base
  has_secure_password

  def self.complete_transaction(session, params)
    user = self.find(session[:id])
    user.balance ||= 0

    if !params[:post][:withdrawal].empty?
      user.update(balance: (user.balance -= params[:post][:withdrawal].to_i))
    else
      user.update(balance: (user.balance += params[:post][:deposit].to_i))
    end
  end
end
