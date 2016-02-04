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
    #your code here!
    if valid_user(params)
      user = User.new(username: params[:username], password_digest: params[:password])
      user.save
      redirect "/login"
    else
      redirect "/failure"
    end
  end


  get "/login" do
    erb :login
  end

  post "/login" do
    #your code here!
    user = User.find_by(username: params[:username])
    # binding.pry
    if valid_user(params) && user.authenticate(params[:password])
      # binding.pry
      session[:id] = user.id
      redirect "/success"
    else
      redirect "/failure"
    end
  end

  get "/success" do
    if logged_in?
      erb :account
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
      !!session[:id]
    end

    def current_user
      User.find(session[:id])
    end

    def valid_user(params)
      if params[:username] == '' || params[:password] == ''
        false
      else
        true
      end
    end
  end

end
