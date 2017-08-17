require "./config/environment"
require "./app/models/user"
class ApplicationController < Sinatra::Base

  configure do
    set :views, "app/views"
    enable :sessions
    set :session_secret, "password_security"
  end

#renders an index.erb file with links to signup or login.
  get "/" do
    erb :index
  end

#renders a form to create a new user. The form includes fields for username and password.
  get "/signup" do
    erb :signup
  end

  post "/signup" do
    user = User.new(:username => params[:username], :password => params[:password])
	if user.save
		 redirect "/login"
	else
		 redirect "/failure"
	end
end

#renders an account.erb page, which should be displayed once a user successfully logs in.
  get '/account' do
    erb :account
  end

#renders a form for logging in.
  get "/login" do
    erb :login
  end

  post "/login" do
    user = User.find_by(:username => params[:username])
		if user && user.authenticate(params[:password])
        session[:id] = user.id
		   	redirect "/account"
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

#renders a failure.erb page. This will be accessed if there is an error logging in or signing up.
  get "/failure" do
    erb :failure
  end

#clears the session data and redirects to the home page.
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
