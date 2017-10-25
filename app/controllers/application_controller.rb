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
    # Assign params to new user instance
    user = User.new(params)
    # If user can be saved to db, send to account page, else failure page
    if user.save
      redirect '/account'
    else
      redirect '/failure'
    end
  end

  get '/account' do
    @user = User.find(session[:user_id])
    erb :account
  end


  get "/login" do
    erb :login
  end

  post "/login" do
    # Find the user by username
    user = User.find_by(:username => params[:username])
    # If user exists & password matches, set session[:user_id] to user.id
    # If success go to account page, else failure page
    if user && user.authenticate(params[:password])
			session[:user_id] = user.id
			redirect '/account'
		else
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
