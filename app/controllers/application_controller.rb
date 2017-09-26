require "pry"
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
    @user = User.new(username: params[:username], password: params[:password])
    if @user.username != "" && @user.save
      redirect '/login'
    else
      redirect '/failure'
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

  post "/deposit" do
    @user = User.find(session[:user_id])
    if @user.balance == nil
      @user.update(balance: params[:amount].to_i)
    else
      @user.update(balance: (params[:amount].to_i + @user.balance))
    end
    redirect '/account'
  end

  post "/withdrawal" do
    @user = User.find(session[:user_id])
    if @user.balance == nil || @user.balance == 0 || @user.balance < params[:amount].to_i
      redirect '/insufficient_funds'
    else
      @user.update(balance: (@user.balance - params[:amount].to_i))
    end
    redirect '/account'
  end

  get "/insufficient_funds" do
    erb :insufficient_funds
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
