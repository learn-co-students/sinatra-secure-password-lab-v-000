require "./config/environment"
require "./app/models/user"
require 'pry'

class ApplicationController < Sinatra::Base

  configure do
    set :views, "app/views"
    enable :sessions
    set :session_secret, "password_security"
  end
#ask about the password_digest thing!! and how can they comepare the password hash to the database if one of them has been encrypted. Can different people have the same username?
  get "/" do
    erb :index
  end

  get "/signup" do
    erb :signup
  end

  post "/signup" do
      if params[:username] == "" || params[:password] == ""
        redirect to '/failure'
      else
        user = User.new(username: params[:username], password: params[:password])
        user.save
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
    puts params
    user = User.find_by(username: params[:username])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect '/success'
    else
      redirect '/failure'
    end
  end

  get "/success" do
    if logged_in?
      # erb :success
      redirect '/account'
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
