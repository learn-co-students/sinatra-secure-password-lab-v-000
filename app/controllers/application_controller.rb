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
    user = User.new(username: params[:username], password: params[:password])
    if user.save
      redirect "/login"
    else
      redirect "/failure"
    end
  end


  get "/login" do
    erb :login
  end

  post "/login" do
    user = User.find_by(username: params[:username])
    if user && user.authenticate(params[:password])
      session[:id] = user.id
      redirect "/account"
    else
      redirect "/failure"
    end
  end

  get "/account" do
    if logged_in?
      erb :account
    else
      redirect "/login"
    end
  end
  
  post "/account/deposit" do 
    if logged_in? 
      deposit(params[:amount])
      erb :success
    else
      redirect "/login"
    end
  end
  
  get "/success" do 
    erb :success
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
      !!session[:id]
    end

    def current_user
      User.find(session[:id])
    end
    
    def deposit(amount)
      if amount.to_f
        user = User.find(session[:id])
        user.balance += amount.to_f
        user.save
        session[:notice] = "Successfully completed deposit of $#{amount}."
      else
        session[:error] = "Please enter a valid amount."
      end
    end
  end

end
