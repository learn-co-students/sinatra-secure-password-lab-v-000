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
    user = User.new(username: params[:username], password: params[:password])

    if params[:username] == "" || params[:password] == ""
        redirect "/failure"
    else
      user.save
      redirect "/login"
    end
  end

  get '/account' do
    @user = User.find(session[:user_id])
    erb :account
  end

  post '/account' do
    deposit = params[:deposit]
    withdrawl = params[:withdrawl]

    if logged_in? 
      if deposit != ""
        balance = current_user.balance + deposit.to_f
      elsif withdrawl != ""
        if withdrawl.to_f > current_user.balance
          redirect to "/failure"
        else
          balance = current_user.balance - withdrawl.to_f
        end
        
      end
      current_user.update(balance: balance)
      redirect to "/account"
    else
       redirect to "/failure"
    end

    
  end

  get "/login" do
    erb :login
  end

  post "/login" do

    user = User.find_by(username: params[:username])
    if params[:username] != "" && user && user.authenticate(params[:password])
        session[:user_id] = user.id
        redirect "/account"
    else
        redirect "/failure"
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
  end

end
