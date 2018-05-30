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
    user = User.new(username: params[:username], password: params[:password])
    if user.save 
      redirect '/login'
    else 
      redirect '/failure'
    end 

  end

  get '/account' do
    if logged_in?
      @user = current_user 
      erb :account
    else 
      erb :failure 
    end 
  end
  
  get '/withdraw' do 
    @user = current_user
    erb :withdraw
  end
  
  get '/deposit' do
    @user = current_user
    erb :deposit
  end

  patch '/withdraw' do 
    if valid_withdrawal?
      user = current_user
      user.balance = user.balance - params[:withdrawal].to_i
      user.save
      redirect '/account'
    else 
      erb :invalid
    end 
  end 
  
  patch '/deposit' do
    if valid_deposit?
      user = current_user
      user.balance = user.balance + params[:deposit].to_i
      user.save 
      redirect '/account'
    else 
      erb :invalid
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
    
    def valid_withdrawal?
      !!(params[:withdrawal].to_i > 0.00 && current_user.balance - params[:withdrawal].to_i > 0.00)
    end
    
    def valid_deposit?
      !!(params[:deposit].to_i > 0.00)
    end 
    
  end

end
