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
    if params["username"].size > 0 && params["password"].size > 0
      erb :login
    else
      erb :failure
    end
  end


  get "/login" do
    erb :login
  end

  post "/login" do
    if params["username"].size > 0 && params["password"].size > 0
      session[:id] = User.find_by(username: params["username"]).id
      erb :account
    else
      erb :failure
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

  get "/account" do
    erb :account
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
