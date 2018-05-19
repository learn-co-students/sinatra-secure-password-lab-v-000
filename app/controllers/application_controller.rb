require "./config/environment"
require "./app/models/user"
require 'pry'
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
    user = User.new(:username => params[:username], :password => params[:password])
    # binding.pry
    if user.username.empty? || user.password_digest == nil
        redirect to '/failure'
    else
        session[:user_id] = user.id
        redirect to '/login'
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
    ##your code heresession[:user_id] == user.id &&
    user = User.find_by(:username => params[:username])
    # binding.pry
    if !params[:username].empty? && !params[:password].empty? && user.authenticate(params[:password])
        session[:user_id] = user.id
        redirect to '/account'
    else
        redirect to '/failure'
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
