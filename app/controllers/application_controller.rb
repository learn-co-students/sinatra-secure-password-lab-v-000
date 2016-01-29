require "./config/environment"
require "./app/models/user"
require 'pry'
class ApplicationController < Sinatra::Base

  configure do
    set :views, "app/views"
    enable :sessions
    set :session_secret, "password_security"
  end

  get "/" do #root page or index page rendering
    erb :index
  end

  get "/signup" do #signup page for new users
    erb :signup
  end

  post "/signup" do #if username/password is blank send to error page else create new user and redirect to login
    if params[:username]=="" || params[:password]==""
      redirect "/failure"
    else
      user = User.new
      user.password = params[:password]
      user.username = params[:username]
      if user.save!
      redirect '/login'
      else
        redirect '/failure'
      end
    end
  end


  get "/login" do #login page rendering
    erb :login
  end

  post "/login" do #process the login page and a session id to keep track of the logged in user
    user = User.find_by(username: params[:username])
    if user && user.authenticate(params[:password])
      session[:id] = user.id
      redirect "/success"
    else
      redirect '/failure'
    end
    
  end

  get "/success" do #if user successfully logs in, they are redirected to the account page else back to login page
    if logged_in?
      @user = User.find_by(sessions[:id])
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
