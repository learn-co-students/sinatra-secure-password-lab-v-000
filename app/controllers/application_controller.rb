require "./config/environment"
require "./app/models/user"
require 'pry'
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
      redirect "/login"
    else
      redirect "/failure"
    end
  end

  get '/account' do
    @user = current_user
    erb :account
  end


  get "/login" do
    erb :login
  end

  post "/login" do
    user = User.find_by(username: params[:username])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect "/success"
    else
      redirect "/failure"
    end
  end

  get "/success" do
    if logged_in?
      redirect "/account"
    else
      redirect "/login"
    end
  end

  get "/failure" do
    erb :failure
  end

  get "/deposit" do
    erb :deposit
  end

  post "/deposit" do
    @user = current_user
    @user.balance += params[:deposit].to_f
    erb :account
  end

  get "/withdraw" do
    erb :withdraw
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

    def withdraw(amount)
      user.balance -= amount
    end
    
    def deposit(amount)
      current_user.balance += amount.to_f
    end
  end

end
