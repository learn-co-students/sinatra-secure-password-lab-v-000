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
    user = User.new(username: params[:username], password: params[:password], balance: 0)
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

  post '/deposit' do
    user = User.find(session[:user_id])
    deposit(user, params[:deposit_amount].to_i)
    redirect '/account'
  end

  post '/withdrawal' do
    user = User.find(session[:user_id])
    amount = params[:withdrawal_amount].to_i
    if enough_money?(user, amount)
      withdraw(user, amount)
      redirect '/account'
    else
      erb :withdraw_error
    end
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
      redirect 'failure'
    end
  end

  get "/success" do
    if logged_in?
      erb :success
    else
      redirect "/login"
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

    def deposit(user, amount)
      user.balance += amount
      user.save
    end

    def withdraw(user, amount)
        user.balance -= amount
        user.save
    end

    def enough_money?(user, amount)
      user.balance >= amount
    end

  end

end
