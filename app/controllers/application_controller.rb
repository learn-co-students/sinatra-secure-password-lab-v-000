require "./config/environment"
require "./app/models/user"
require 'sinatra/flash'
class ApplicationController < Sinatra::Base

  configure do
    set :views, "app/views"
    enable :sessions
    set :session_secret, "password_security"
    register Sinatra::Flash
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
      redirect '/login'
    else
      redirect '/failure'
    end
  end

  get '/account' do
    @user = current_user
    if logged_in?
      erb :account
    else
      redirect '/login'
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

  patch '/account' do
    @user = current_user
    amount = params[:amount].to_f
    if params[:commit] == 'Deposit'
      User.update(@user.id, balance: @user.balance += amount)
    elsif params[:commit] == 'Withdraw' && @user.balance >= amount
      User.update(@user.id, balance: @user.balance -= amount)
    else
      flash[:warning] = "Insufficient Funds"
    end
    redirect to '/account'
  end

  helpers do
    def logged_in?
      !!session[:user_id]
    end

    def current_user
      @current_user ||= User.find(session[:user_id])
    end
  end
end
