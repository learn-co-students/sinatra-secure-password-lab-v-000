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
    #your code here
    user = User.new(:username => params[:username], :password => params[:password])

      if !user.username.empty? && user.save
        redirect '/login'
      else
        redirect '/failure'
      end
  end

  get '/account' do
    @user = User.find(session[:user_id])
    erb :account
  end

  post '/account/deposit' do
    deposit_amount = params[:amount].to_i
    user = User.find(session[:user_id])
    user.balance += deposit_amount
    user.save
    redirect '/account'
  end

  post '/account/withdraw' do
    withdraw_amount = params[:amount].to_i
    user = User.find(session[:user_id])
    if user.balance > withdraw_amount
      user.balance -= withdraw_amount
      user.save
      redirect '/account'
    else
      redirect '/failure'
    end
  end


  get "/login" do
    erb :login
  end

  post "/login" do
    ##your code here
    user = User.find_by(:username => params[:username])

    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect "/account"
    else
      redirect "/failure"
    end
  end

  get "/failure" do
    erb :failure
  end

  get "/logout" do
    session.clear
    redirect "/"
  end

  helpers do
    def logged_in?
      !!session[:user_id]
    end

    def current_user
      User.find(session[:user_id])
    end

    def deposit(money)
      current_user.balance += money
      current_user.save
    end

    def withdraw(amount)
      if amount < current_user.balance
        current_user.balance -= amount
      else
        "Amount exceeds your available funds"
      end
    end
  end

end
