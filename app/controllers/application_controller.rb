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
      redirect to "/failure"
    else
      redirect to "/login"
    end
  end

  get "/account" do
    erb :account
  end

  get "/login" do
    erb :login
  end

  post "/login" do
    @user = User.find_by(:username => params[:username])
    if params[:username] == "" || params[:password] == ""
      redirect to "/failure"
    elsif @user && @user.authenticate(params[:password])
      session[:id] = @user.id
      redirect to "/account"
    end
    redirect to "/failure"
  end

  get "/success" do
    if logged_in?
      erb :success
    else
      redirect to "/login"
    end
  end

  get "/failure" do
    erb :failure
  end

  get "/logout" do
    session.clear
    redirect to "/"
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
