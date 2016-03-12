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
      redirect "/login"
    else
      redirect "/failure"
    end
  end

  get '/account' do
    if logged_in?
      @user = current_user
    else
      @user = nil
    end
    erb :account
  end


  get "/login" do
    erb :login
  end

  post "/login" do
    ##your code here
    user = User.find_by(username: params[:username])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect "/account"
    else
      redirect "/failure"
    end
  end

  post "/withdrawal" do 
    user = User.find_by(id: session[:user_id])
    balance = user.balance
    modified_balance = balance - params[:withdrawal_amount].to_f
    if modified_balance >= 0
      user.update(balance: modified_balance)
      redirect "/account"
    else
      redirect "/failure"
    end
  end

  post "/deposit" do
    user = User.find_by(id: session[:user_id])
    balance = user.balance
    user.update(balance: balance + params[:deposit_amount].to_f)
    redirect "/account"
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
      User.find_by(id: session[:user_id])
    end
  end

end
