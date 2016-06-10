require "./config/environment"
require "./app/models/user"
require "pry"
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

		if (params[:username] != "" && params[:password] != "")
      user = User.new(:username => params[:username], :password => params[:password])
      user.save
      redirect "/login"
    else
      redirect "/failure"
    end
  end

  get '/account' do
    user = User.find(session[:user_id])
    erb :account
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

  get "/account" do
    if logged_in?
      user = User.current_user
      erb :account
    else
      redirect "/login"
    end
  end

  get "/failure" do
    erb :failure
  end
  get '/account_summary' do
    erb :account_summary
  end

  get '/withdraw' do
    erb :withdraw
  end

  post '/withdraw' do
    withdraw(params[:amount])
    redirect '/account_summary'
  end

  get '/deposit' do
    erb :deposit
  end

  post '/deposit' do
    deposit(params[:amount])
    redirect '/account_summary'
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

    def deposit(amount)
      @user = current_user
      @user.balance += amount.to_i
      @user.save
    end

    def withdraw(amount)
      @user = current_user
      if amount.to_i < @user.balance
        @user.balance -= amount.to_i
        @user.save
      else
        "Withdraw amount must be less than your balance!"
      end
    end
  end

end
