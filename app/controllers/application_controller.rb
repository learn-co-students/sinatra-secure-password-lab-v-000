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
    @user = User.new(:username => params[:username], :password => params[:password])
		if @user.save
        redirect "/account"
    else
        redirect "/failure"
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
    @user = User.find_by(:username => params[:username])
		if @user && @user.authenticate(params[:password])
		    session[:user_id] = @user.id
        redirect "/account"
    else
        redirect "/failure"
    end
  end

  patch "/deposit" do
      @user = User.find(session[:user_id])
      balance = @user.balance.to_f + params[:deposit].to_f
      @user.update(balance: balance)
      redirect "/account"
    end

  patch "/withdraw" do
    @user = User.find(session[:user_id])
    balance = @user.balance.to_f - params[:withdrawal].to_f
    if balance >= 0
      @user.update(balance: balance)
    else
      withdrawal_error
    end
    redirect "/account"
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

   def withdraw_error
    "Sorry you can't take money from nothing"
  end
  end

end
