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
    user = User.new(username: params[:username], password: params[:password])
    
    if user.username.blank? || user.password.blank?
      # Note: #blank? is not standard Ruby; it's provided by the ActiveSupport gem. See https://blog.appsignal.com/2018/09/11/differences-between-nil-empty-blank-and-present.html
      redirect "/failure"
    else 
      user.save
      redirect "/login"
    end
  end

  get '/account' do
    # This makes sure that a hacker can't login through the account route directly, although the tests don't check for this.
    if logged_in?
      @user = User.find(session[:user_id])
      erb :account
    else
      redirect "/failure"
    end
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
