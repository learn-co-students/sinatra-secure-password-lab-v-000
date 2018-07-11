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
    if @user.save && @user.username != ""
      redirect "/login"
    else
      redirect "/failure"
    end
  end

  get '/account' do
    @user = User.find(session[:user_id])
    erb :account
  end
  
  post '/deposit' do
    @user = User.find(session[:user_id])
    @old_balance = @user.balance.to_f
    @deposit = params[:deposit].to_f
    @user.update(balance: @old_balance + @deposit)
    redirect '/account'
  end
  
  post '/withdraw' do
    @user = User.find(session[:user_id])
    @old_balance = @user.balance.to_f
    @withdraw = params[:withdraw].to_f
    if @withdraw <= @old_balance
      @user.update(balance: @old_balance - @withdraw)
      redirect '/account'
    else
      redirect '/account'
    end
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

  helpers do
    def logged_in?
      !!session[:user_id]
    end

    def current_user
      User.find(session[:user_id])
    end
  end

end
