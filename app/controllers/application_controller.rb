require "./config/environment"
require "./app/models/user"
require "pry"
require "bcrypt"

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
    user = User.new(:username => params[:username], :password => params[:password])
    if user.save
      redirect "/login"
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
    user = User.find_by(username: params[:username])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect '/success'
    else
      redirect '/failure'
    end

  end

  get "/success" do
    if logged_in?
      redirect '/account'
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

  get "/deposit" do #gets the balance from the user, and adds to it any amount
    @user = User.find_by(id: session[:user_id])
    if @user && logged_in?
      erb :deposit
    else
      redirect "/failure"
    end
  end

  post "/deposit" do
    user = User.find_by(id: session[:user_id])
    if user && logged_in?
      user.update(balance: user.balance + params[:deposit_amount].to_i)
      redirect "/account"
    else
      redirect "/failure"
    end

  end

  get "/withdrawl" do #gets the balance from the user and subtracts to it any amount less than the balance
    @user = User.find_by(id: session[:user_id])
    if @user && logged_in?
      erb :withdrawl
    else
      redirect "/failure"
    end
  end

  post "/withdrawl" do
    user = User.find_by(id: session[:user_id])
    if user && logged_in?
      user.update(balance: user.balance - params[:withdrawl_amount].to_i)
      redirect "/account"
    else
      redirect "/failure"
    end
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
