require "./config/environment"
require "./app/models/user"
class ApplicationController < Sinatra::Base

  configure do
    set :views, "app/views"
    enable :sessions
    set :session_secret, "password_security"
  end

#get "/" do renders an index.erb file with links to signup or login.
  get "/" do
    erb :index
  end

#get '/signup' renders a form to create a new user. The form includes fields for username and password.
  get "/signup" do
    erb :signup
  end

  post "/signup" do
    if params[:username] == "" || params[:password] == ""
      redirect '/failure'
    else
      User.create(params)
      redirect '/login'
    end
  end

#get '/account' renders an account.erb page, which should be displayed once a user successfully logs in.
  get '/account' do
    @user = User.find(session[:user_id])
    erb :account
  end

#get '/login' renders a form for logging in.
  get "/login" do
    erb :login
  end

  post "/login" do
    user = User.find_by(username: params[:username])
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

#get '/failure' renders a failure.erb page. This will be accessed if there is an error logging in or signing up.
  get "/failure" do
    erb :failure
  end

#get '/logout' clears the session data and redirects to the home page.
  get "/logout" do
    session.clear
    redirect "/"
  end

#allow us to add logic to our views. Views automatically have access to all helper methods thanks to Sinatra.
  helpers do
    def logged_in?
      !!session[:user_id]
    end

    def current_user
      User.find(session[:user_id])
    end
  end

end
