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
    user = User.new(username: params[:username], password: params[:password], balance: 0.00)
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
      redirect to "/account"
    else
      redirect to "/failure"
    end
  end

  get "/account" do
    if logged_in?
      @user = current_user
      erb :account
    else
      redirect "/login"
    end
  end

  get "/failure" do
    erb :failure
  end

  patch "/account" do
    @user = current_user
    funds = @user.balance
    if !User.input_valid?(params)
      erb :balance_error
    elsif !User.update_balance(funds, params)
      erb :balance_error
    else
      new_balance = User.update_balance(funds, params)
      @user.balance = new_balance
      @user.save
      erb :account
    end
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
  end

end
