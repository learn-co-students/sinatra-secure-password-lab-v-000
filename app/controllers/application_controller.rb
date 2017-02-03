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
    if user.save
      #session[:user_id] = user.id
      redirect '/login'
    else
      redirect '/failure'
    end
  end

  get '/account' do
    if logged_in?
      erb :account
    else
      redirect '/login'
    end
  end

  get "/login" do
    if logged_in?
      redirect '/account'
    else
      erb :login
    end
  end

  post "/login" do
    login(params[:username], params[:password])
    redirect '/account'
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
    logout
    redirect "/"
  end

  helpers do
    def logged_in?
      !!current_user
    end

    def current_user
      @current_user ||= User.find_by(id: session[:user_id])
    end

    def login(username, password)
      user = User.find_by(username: username)
      if user && user.authenticate(password)
        session[:user_id] = user.id
      else
        redirect '/failure'
      end
    end

    def logout
      session.clear
    end
  end

end
