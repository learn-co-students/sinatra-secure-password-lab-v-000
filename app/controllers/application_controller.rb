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
    user = User.new(password: params[:password], username: params[:username])
    user.save
    if user.id
      redirect to '/login'
    else
      redirect to '/failure'
    end
  end

  get '/account' do
    if session[:user_id]
      @user = User.find(session[:user_id])
      erb :account
    else
      redirect '/failure'
    end
  end

  post '/deposit' do
    deposit = params[:deposit].to_i
    user = current_user
    if deposit > 0
      user.balance += deposit
      user.save
    end
    redirect '/account'
  end

  post '/withdraw' do
    withdraw = params[:withdraw].to_i
    user = current_user
    if withdraw > 0 && withdraw < user.balance
      user.balance -= withdraw
      user.save
    end
    redirect '/account'
  end

  get "/login" do
    erb :login
  end

  post "/login" do
    user = User.find_by(username: params[:username])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect to '/account'
    else
      redirect to '/failure'
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
