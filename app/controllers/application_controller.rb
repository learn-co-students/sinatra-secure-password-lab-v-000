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
    user = User.new(username: params[:username], password: params[:password], balance: 0)
    
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
      redirect '/'
    end 
  end

  get "/login" do
    erb :login
  end

  post "/login" do
    user = User.find_by(username: params[:username])
    if !!user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect '/account'
    else 
      redirect '/failure'
    end 
  end

  get "/failure" do
    erb :failure
  end
  
  get "/deposit" do 
    erb :deposit 
  end 
  
  get "/withdrawal" do
    @direction = "Enter amount below"
    erb :withdrawal
  end 
  
  post "/deposit" do
    @new_balance = current_user.balance + params[:deposit].to_i 
    current_user.update(balance: @new_balance)
    redirect '/account' 
  end 
  
  post "/withdrawal" do
    if params[:withdraw].to_i < current_user.balance
      @new_balance = current_user.balance - params[:withdraw].to_i
      current_user.update(balance: @new_balance)
      redirect '/account' 
    else 
      @direction = "I'm sorry that is more than what you have in your account. Try again."
      erb :withdrawal
    end 
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
