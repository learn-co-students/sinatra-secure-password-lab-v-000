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
    user = User.new(:username => params[:username], :password => params[:password], :balance => 0)
    if user.save
      redirect '/login'
    else
      redirect '/failure'
    end   
  end


  get "/login" do
    erb :login
  end

  post "/login" do
    user = User.find_by(:username => params[:username])
    if user && user.authenticate(params[:password])
      session[:id] = user.id
      redirect '/account'
    else
      redirect '/failure'
    end    
  end

  get "/account" do
    if logged_in?
      @user = current_user
      erb :account
    else
      redirect "/login"
    end
  end

  post "/account" do
    if !withdrawal_deposit_approval(params)
      erb :account_failure
    else
      redirect "/account"
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
      !!session[:id]
    end

    def current_user
      User.find(session[:id])
    end

    def withdrawal_deposit_approval(params)
      withdrawal = params[:withdrawal_amount]
      deposit = params[:deposit_amount]
      @user = current_user
      if deposit.to_i > 0
        @user.balance += deposit.to_i
        @user.save
      elsif  @user.balance >= withdrawal.to_i
        @user.balance -= withdrawal.to_i
        @user.save 
      else
        false  
      end    
    end
  end

end
