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
    user = User.create(:username => params[:username], :password => params[:password])
    if user.username != nil
      redirect to "/failure"
    else
      redirect to "/login"
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

    user = User.find_by(:username => params[:username])
    #binding.pry
    if user == nil
      redirect to "/failure"
    elsif user.username == nil
      redirect to "/failure"
    elsif user.authenticate(params[:password])
      redirect to "/account"
    else
      redirect to "/failure"
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
