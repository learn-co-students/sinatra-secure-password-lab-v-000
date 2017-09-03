require "./config/environment"
require "./app/models/user"
class ApplicationController < Sinatra::Base

  configure do
    set :views, "app/views"
    enable :sessions
    set :session_secret, "password_security"
  end

  get "/" do
    # renders page with links to signup or login
    erb :index
  end

  get "/signup" do
    #renders signup form for creating a new user
    erb :signup
  end

  post "/signup" do
    # if either the username or password field is blank redirect to /failure
    # else create (and save) the new user and redirect to /login
    if params[:username] == "" || params[:password] == ""
      redirect to '/failure'
    else
      user = User.new(username: params[:username], password: params[:password])
      user.save
      redirect to '/login'
    end
  end

  get '/account' do
    # renders account page that displays once user is successfully logged in
    @user = User.find(session[:user_id])
    erb :account
  end


  get "/login" do
    # renders login form
    erb :login
  end

  post "/login" do
    # find the user based on the given username
    # this also guards against empty username and password fields
    # if the user is not nil and the password is valid then set the session[:user_id] and redirect to /account
    # else redirect to /failure
    user = User.find_by(username: params[:username])
    if user != nil && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect to '/account'
    else
      redirect to '/failure'
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
    # renders if there is an error logging in or signing up
    erb :failure
  end

  get "/logout" do
    # clears session hash
    session.clear
    redirect "/"
  end

# views automatically have access to these methods
  helpers do
    def logged_in?
      !!session[:user_id]
    end

    def current_user
      User.find(session[:user_id])
    end
  end

end
