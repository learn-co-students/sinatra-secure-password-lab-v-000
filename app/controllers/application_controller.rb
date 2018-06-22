require "./config/environment"
require "./app/models/user"
require "pry"

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
    #binding.pry
    if params[:username] == ""
      redirect "/failure"
    else
      user = User.new(:username => params[:username], :password => params[:password])
      session[:user_id] = user.id
      #binding.pry

      if user.save
          redirect "/login"
      else
          redirect "/failure"
      end
    end

  end

  get '/account' do
    #binding.pry
    #@user = User.find(session[:user_id])
    #binding.pry
    erb :account
  end


  get "/login" do
    #binding.pry
    #user = User.find_by(username: params[:username], password: params[:password])

		erb :login

  end

  post "/login" do
    ##your code here
    if params[:username] == "" || params[:password] == "" || params[:username] == nil || params[:password] == nil
      #binding.pry
      redirect '/failure'
      #binding.pry
    else
      #binding.pry
      redirect '/account'
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
