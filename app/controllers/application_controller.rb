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
    if params[:username] == "" || params[:password] == ""
      redirect "/failure"
    else
      user = User.create(username: params[:username], password: params[:password], balance: 500)
      redirect "/login"
    end
  end

  get "/account" do
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

  get "/success" do
    if logged_in?
      erb :success
    else
      redirect "/login"
    end
  end

  get '/logout' do
    session.clear
    redirect "/"
  end

  get "/withdraw_error" do
    erb :withdraw_error
  end

  patch "/account/withdraw" do
    if logged_in?
      user = User.find(session[:user_id])
      if user.balance < params[:withdraw].to_i
        redirect "/withdraw_error"
      else
        user.balance -= params[:withdraw].to_i
        user.save
        redirect "/account"
      end
    else
      redirect "/failure"
    end

  end

  patch "/account/deposit" do
    if logged_in?
      user = User.find(session[:user_id])
      user.balance += params[:deposit].to_i
      user.save
      redirect "/account"
    else
      redirect "/failure"
    end
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
