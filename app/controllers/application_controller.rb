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
    #your code here
    user = User.new(:username => params[:username], :password => params[:password], :balance => 0.0)
    if user.save && !user.username.empty?
      redirect "/login"
    else
      redirect "/failure"
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
    ##your code here
    user = User.find_by(username: params[:username])

    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
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

  patch "/users/deposit/:id" do
    new_balance = current_user.balance + params[:amount].to_f
    current_user.update(balance: new_balance)
    redirect "/account"
  end

  patch "/users/withdrawl/:id" do
    new_balance = current_user.balance - params[:amount].to_f
    if new_balance >= 0.0
      current_user.update(balance: new_balance)
      redirect "/account"
    else
      erb :with_fail
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
