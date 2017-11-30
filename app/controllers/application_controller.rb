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
    #your code here

    if params[:username] != "" && params[:password] != "" # Did this to get tests to pass, but not sure if
      # this is the right way to handle
      user = User.new(:username => params[:username], :password => params[:password])
		  if user.save
				redirect "/account"
        # not sure how this works...the instance of User has a readable string from
        # params[:password}...are we then saving THAT to the database?? At what point does it get encyrpted under
        # :password_digest??
        # BUT when I use sqlite3 to look at what's in database, it works -- there are the hashes, and no
        # plain text passwords
      end
		else
				redirect "/failure"
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
    ##your code here
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
      @user = current_user # I added
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
