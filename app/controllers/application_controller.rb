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
    erb :index#with links to signup or login
  end

  get "/signup" do
    erb :signup#to create a new user. The form includes fields for `username` and `password`
  end

  post "/signup" do
    #your code here
    #params passed in from Get '/signup'
    #binding.pry
    @user = User.new(:username => params[:username], :password => params[:password])# a new instance of our user class with a username and password from params
    #  binding.pry
    if @user.save && @user.username != ""#Calling user.save will return false if fails to fill_out pswd
      redirect '/login' #to allow user to access login pg
    else
    #  binding.pry
      redirect '/failure'#accessed if sign in fails b/c save failure
    end
  end

  get '/account' do
    if logged_in?
      erb :account#be displayed once a user successfully logs in
    elsif current_user
      erb :account
    else
      erb :error
    end
  end

  get "/login" do
    erb :login
  end

  post "/login" do
      @user = User.find_by(:username => params[:username])#find the user by username.
      if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id#session is user
          redirect '/account'
      else @user == nil
          redirect '/failure'
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
    erb :failure#be accessed if there is an error logging in or signing up
  end

  get "/logout" do
    session.clear#clears the session data
    redirect "/"#{and redirects to the home page}
  end
#Views automatically have access to all helper methods thanks to Sinatra
  helpers do
    def logged_in?
      !!session[:user_id]#eturns true or false based on the presence of a `session[:user_id]
    end

    def current_user
      User.find(session[:user_id])#returns the instance of the logged in user, based on the `session[:user_id]
    end

  end
end
