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
    @user = User.new(:username => params[:username], :password => params[:password], :balance => "0")

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
  
  get '/deposit' do
    @user = User.find(session[:user_id])
    erb :deposit
  end
  
  get '/withdrawal' do
    @user = User.find(session[:user_id])
    erb :withdrawal
  end
  
  post '/withdrawal' do
    @user = User.find(session[:user_id])

    if params[:amount].to_i <= @user.balance.to_i
      session[:amount], session[:action] = params[:amount], "withdrawal"
      new_balance = @user.balance.to_i - params[:amount].to_i
      
      @user.update(:balance => new_balance.to_s)
      
      redirect "/success"
    else
      erb :insufficient_funds
    end
  end

  post '/deposit' do
    @user = User.find(session[:user_id])
    session[:amount], session[:action] = params[:amount], "deposit"
    new_balance = @user.balance.to_i + params[:amount].to_i
    
    @user.update(:balance => new_balance.to_s)
    
    redirect "/success"
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
      @user = User.find(session[:user_id])
      @amount, @action = session[:amount], session[:action]
      
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
