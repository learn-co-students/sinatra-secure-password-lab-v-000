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
    user = User.new(username: params[:username], password: params[:password], password_confirmation: params[:password_confirmation], balance: params[:balance])
    if params[:username].empty? || params[:password].empty?
      redirect "/failure"
    else 
      user.save
      redirect "/login"
    end
  end


  get "/login" do
    erb :login
  end

  post "/login" do
    if params[:username].empty? || params[:password].empty?
      redirect "/failure"
    else
      if User.find_by(username: params["username"]) != nil
        user = User.find_by(username: params["username"])
        user.password == user.password_confirmation
        session["id"] = user.id
        redirect "/success" 
      else
        redirect "/failure"
      end
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
  end

end
