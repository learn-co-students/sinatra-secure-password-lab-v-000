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
    user = User.new(username: params[:username], password: params[:password])

    if user.save
      redirect to "/login"
    else
      redirect to "/failure"
    end
  end

  get "/account" do
    if logged_in?
      erb :account
    else
      redirect to "/login"
    end
  end

  get "/login" do
    erb :login
  end

  post "/login" do
    user = User.find_by(username: params[:username])

    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect to "/account"
    else
      redirect to "/failure"
    end
  end

  get "/failure" do
    erb :failure
  end

  get "/withdraw" do
    if logged_in?
      erb :withdraw
    else
      redirect to "/login"
    end
  end

  post "/withdraw" do
    withdrawal = params[:amount].to_d
    if withdrawal > current_user.balance
      redirect to "/withdraw"
    else
      current_user.update(balance: current_user.balance - withdrawal)
      redirect to "/account"
    end
  end

  get "/deposit" do
    if logged_in?
      erb :deposit
    else
      redirect to "/login"
    end
  end

  post "/deposit" do
    deposit = params[:amount].to_d
    current_user.update(balance: current_user.balance + deposit)

    redirect to "/account"
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
