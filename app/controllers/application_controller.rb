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
    #your code here!
    if params[:username] == "" || params[:password] == ""
      redirect "/failure"
    else
      user = User.new(:username => params[:username], :password => params[:password])
    end

    if user.save
      redirect "/login"
    else
      redirect "/failure"
    end
  end

  get '/account' do
    erb :account
  end

  get "/login" do
    erb :login
  end

  post "/login" do
    #your code here!
    @user =  User.find_by(:username => params[:username])
    if params[:username] == "" || params[:password] == ""
      redirect '/failure'
    else
      session[:id] = @user.id
      redirect '/account'
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
      !!session[:id]
    end

    def current_user
      User.find(session[:id])
    end
  end

end