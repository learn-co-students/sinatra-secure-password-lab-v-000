require "./config/environment"
require "./app/models/user"
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

  patch '/deposit' do

    user = User.find_by_id(session[:user_id])

    user.update_attribute(:balance, (user.balance += params[:deposit_amount].to_i))
    redirect '/account'
  end

  patch '/withdraw' do
    user = User.find_by_id(session[:user_id])
    withdraw_amount = params[:withdraw_amount].to_i

    if user.balance >= withdraw_amount
      user.update_attribute(:balance, (user.balance -= params[:withdraw_amount].to_i))
      redirect '/account'
    else
      redirect "/account_withdraw_failure"
    end

  end

  get "/account_withdraw_failure" do
    erb :account_withdraw_failure
  end

  get "/login" do
    erb :login
  end

  post "/login" do
    user = User.find_by(:username => params[:username])

    if user && user.authenticate(params[:password])
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
