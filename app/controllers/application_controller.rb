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
    user = User.new(username: params[:username], password: params[:password])
    if !user.username.empty? && user.save
      redirect "/login"
    else
      redirect "/failure"
    end
  end

  get '/account' do
    current_user
    erb :account
  end

  post '/account' do
    #raise params.inspect
    if !params[:deposit].empty?
      balance = (current_user.balance += params[:deposit].to_f)
      current_user.update(balance: balance)
      redirect "/account"
      
    elsif !params[:withdraw].empty? && (current_user.balance > params[:withdraw].to_f)
      balance = (current_user.balance -= params[:withdraw].to_f)
      current_user.update(balance: balance) 
      redirect "/account"

    else
      redirect "/account"
    end
  end


  get "/login" do
    erb :login
  end

  post "/login" do
    user = User.find_by(username: params[:username])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect "/account"
    else
      redirect "/failure"
    end
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
      User.find(session[:user_id])
    end
  end
end
