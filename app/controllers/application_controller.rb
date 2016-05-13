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

    if user.username != "" && user.password != ""
      user.save
      redirect '/login'
    else
      redirect '/failure'
    end
  end

  get '/account' do
    @user = User.find(session[:user_id])
    erb :account
  end

  get '/deposit' do
    @user = User.find(session[:user_id])
    erb :deposit
  end

  post '/deposit' do
    user = User.find(session[:user_id])
    deposit_amount = params[:deposit].to_f
    user.balance += deposit_amount
    user.save
    redirect '/deposit'
  end

  get '/withdraw' do
    @user = User.find(session[:user_id])
    erb :withdraw
  end

  post '/withdraw' do
    user = User.find(session[:user_id])
    withdraw_amount = params[:withdraw].to_f

    if user.balance > withdraw_amount
      user.balance -= withdraw_amount
      user.save
      redirect "/withdraw"
    else
      redirect "/failure"
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
      redirect '/failure'
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
    def logged_in?(session)
      !!session[:user_id]
    end

    def current_user(session)
      User.find(session[:user_id])
    end
  end

end
