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
    if params[:username] == "" || params[:password] == ""
      redirect '/failure'
    else
      user = User.create(username: params[:username], password: params[:password])
      redirect '/login'
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
    @user = User.find_by(username: params[:username])
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect '/account'
    else
      redirect '/failure'
    end
  end

  get '/withdrawal' do
    erb :withdrawal if current_user
  end

  post '/withdrawal' do
    @user = current_user
    @withdrawal = params[:withdrawal].to_f
    if @withdrawal <= @user.balance
      updated = @user.balance -= @withdrawal
      @user.update(balance: updated)
      erb :show_withdrawal
    else
      redirect '/account'
    end
  end

  get '/deposit' do
    erb :deposit if current_user
  end

  post '/deposit' do
    @user = current_user
    @deposit = params[:deposit].to_f
    updated = @user.balance += @deposit
    @user.update(balance: updated)
    erb :show_deposit
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
