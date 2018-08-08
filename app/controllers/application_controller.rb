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
    @user = User.create(username: params[:username], password: params[:password])
    if !@user.username || !@user.password || @user.username == "" || @user.password == ""
      redirect "/failure"
    else
      @user.save
      redirect "/login"
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
      redirect "/account"
    else
      redirect "/failure"
    end
  end

  get "/failure" do
    erb :failure
  end

  get "/logout" do
    session.clear
    redirect "/"
  end

  get "/deposit" do
    erb :deposit
  end

  post "/deposit" do
    @user = current_user
    @amount = params[:deposit].to_i
    @balance = @user.balance
    if @balance == nil
      @balance = 0
    else
      @balance
    end
    @new_balance = @amount + @balance
    @user.balance = @new_balance
    @user.save
    redirect "/account"
  end

  get "/withdrawl" do
    erb :withdrawl
  end

  post "/withdrawl" do
    @user = current_user
    @amount = params[:withdrawl].to_i
    @balance = @user.balance
    if @balance == nil
      @balance == 0
    elsif @balance == 0
      redirect "/insufficient"
    elsif @balance < @amount
      redirect "/insufficient"
    else
      @new_balance = @balance - @amount
      @user.balance = @new_balance
      @user.save
      redirect "/account"
    end
  end

  get '/insufficient' do
    @user = User.find(session[:user_id])
    erb :insufficient
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
