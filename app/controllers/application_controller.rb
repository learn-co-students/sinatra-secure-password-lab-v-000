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
    if params[:username] != "" && params[:password]
      user = User.new(:username => params[:username], :password => params[:password], :balance => 100)
      if user.save
        redirect "/login"
      else
        redirect "/failure"
      end
    else
      redirect "/failure"
    end
  end

  get '/account' do
    @user = User.find(session[:user_id])
    erb :account
  end

  post '/account' do
    user = current_user 
    withdraw = params[:withdraw].to_i
    user.error = "no error"
    balance = user.balance.to_i
    if balance > 0
      if balance - withdraw >= 0
        balance -= withdraw
      else
        user.error = "Your balance can't cover that big of a withdraw."
        redirect "account_error"
      end
    else
      user.error = "You don't have any money to withdraw."
      redirect "account_error"
    end
  end

  get "/account_error" do 
    binding.pry
    user = current_user
    @error = user.error
    erb :account_error
  end


  get "/login" do
    erb :login
  end

  post "/login" do
    ##your code here
    if params[:usernname] != "" && params[:password]
      user = User.find_by(:username => params[:username])
      if user && user.authenticate(params[:password])
        session[:user_id] = user.id 
        redirect "/account"
      else
        redirect "/failure"
      end
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
