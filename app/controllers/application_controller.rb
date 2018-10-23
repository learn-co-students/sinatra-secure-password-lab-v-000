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
  	if params[:username] == nil || params[:username] == ""
      redirect '/failure'
    elsif params[:password] == nil || params[:password] == ""
      redirect "/failure"
    else
      redirect '/login'
    end
    @user = User.create(:username => params[:username], :password => params[:password])
    session[:user_id] = @user.id #This is a good thing to keep, despite the lab not requiring it.
  end


  get '/account' do
    @user = User.find(session[:user_id])
    erb :account
  end


  get "/login" do
    erb :login
  end

  post "/login" do
    # if params[:username].empty?
    #   redirect '/failure'
    # elsif params[:password].empty?
    #   redirect '/failure'
    # else
      @user = User.find_by(:username => params[:username])
        if @user && @user.authenticate(params[:password])
          session[:user_id] = @user.id
          redirect '/account'
        else
          redirect '/failure'
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
