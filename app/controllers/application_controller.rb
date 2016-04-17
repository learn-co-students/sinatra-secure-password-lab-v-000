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
    @username = params["username"]
    @password = params["password"]
    user = User.new(username: @username, password: @password)
    if !user.username.empty? && user.save
      redirect '/login'
    else
      redirect '/failure'
    end

  end

  get '/account' do
    @user = User.find(session[:user_id])
    erb :account
  end
  
  patch '/account' do
    @user = User.find(session[:user_id])
    @amount = params["amount"].to_f
    if params["deposit"]
      @user.balance += @amount
    elsif params["withdraw"]
      if @user.balance >= @amount
        @user.balance -= @amount
      end
    end
    @user.save    
    redirect '/account'
  end


  get "/login" do
    erb :login
  end

  post "/login" do
    user = User.find_by(username: params["username"])
    if user && user.authenticate(params["password"])
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