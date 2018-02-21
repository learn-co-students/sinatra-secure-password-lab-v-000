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
    if params[:username] == "" || params[:password] == ""
      redirect '/failure'
    else
    user = User.new(username: params[:username], password: params[:password])

    if user.save
      redirect '/login'
    end
  end
  end

  get '/account' do
    @user = User.find_by(session[:user_id])
    erb :account
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

  get "/account" do
    if logged_in?
      erb :account
    else
      redirect "/login"
    end
  end

  # Bonus Code
  post "/account" do
    new_balance = current_user.balance + params[:deposit].to_i - params[:withdrawal].to_i
    if new_balance < 0
      redirect '/account'
    else
    current_user.update(balance: new_balance)
    erb :account
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
