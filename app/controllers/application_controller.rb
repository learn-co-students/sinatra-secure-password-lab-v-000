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
    if params[:username].empty? || params[:password].empty?
      redirect '/failure'
    else
      @user = User.create(params)

      redirect '/login'
    end
  end

  get '/account' do
    @user = current_user
    erb :account
  end


  get "/login" do
    erb :login
  end

  post "/login" do
    @user = User.find_by(username: params[:username])
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect to '/account'
    else
      redirect to 'failure'
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
    logout!
    redirect "/"
  end

  helpers do
    def logged_in?
      !!current_user
    end

    # def login(username, password)
    #     user = User.find_by(:username => username)
    #   if user && user.authenticate(password)
    #     session[:id] = user.id
    #   else
    #     redirect '/login'
    #   end
    # end
    #
    def current_user
      @current_user ||= User.find(session[:id]) if session[:id]
    end

    def logout!
      session.clear
    end
  end

end
