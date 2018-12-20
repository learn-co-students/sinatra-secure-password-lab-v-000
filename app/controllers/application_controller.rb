require "./config/environment"
require "./app/models/user"
class ApplicationController < Sinatra::Base

  configure do
    set :views, "app/views"
    enable :sessions
    set :session_secret, "password_security"
  end

  get "/" do
    erb :index
  end

  get "/signup" do
    erb :signup
  end

  post "/signup" do
    user = User.new(username: params[:username], password: params[:password])
    if user.save
      redirect '/login'
    else
      redirect '/failure'
    end
  end

  get '/account' do
    @user = User.find(session[:user_id])
    erb :account
  end

  get "/login" do
    erb :login
  end

  post "/login" do
    user = User.find_by(username: params[:username])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect '/account'
    else
      redirect '/failure'
    end
  end

  get "/failure" do
    erb :failure
  end

  get "/logout" do
    session.clear
    redirect '/'
  end

  # still working on getting the balance to update for a user after a deposit or withdrawal
  post "/deposit" do
    blah = current_user.balance + params[:deposit].to_d
    # puts blah
    # User.update_attribute(current_user.id, :balance => blah)
    puts current_user.update(username: params[:username], password: params[:password], balance: blah)
    # current_user.save
    # puts current_user.balance
  end

  # post "/withdrawal" do
  #   withdrawal(params[:withdrawal].to_d)
  #   # redirect '/account'
  # end

  helpers do
    def logged_in?
      !!session[:user_id]
    end

    def current_user
      User.find(session[:user_id])
    end

    def deposit(amount)
      new_balance = current_user.balance + amount.to_d
      current_user.update(balance: new_balance)
      # sprintf("%.2f", balance)
    end

    def withdrawal(amount)
      if current_user.balance >= amount
        current_user.balance = current_user.balance - amount
      else
        current_user.balance = current_user.balance
      end
      sprintf("%.2f", balance)
    end

    # def current_balance
    #   # balance = current_user.balance + deposit - withdrawal
    #   # sprintf("%.2f", balance)
    # end
  end

end
