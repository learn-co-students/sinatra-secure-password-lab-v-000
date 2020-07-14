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
    #your code here
    if params[:username] == "" || params[:password] == ""
      redirect '/failure'
    else
      User.create(username: params[:username], password: params[:password], balance: 0)
      redirect '/login'
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
    redirect '/account'
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
      redirect "/account"
    else
      redirect "/failure"
    end
  end


  get "/login" do
    erb :login
  end

  post "/login" do
    ##your code here
    @user = User.find_by(username: params[:username])
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect to "/account"
    else
      redirect to "/failure"
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
