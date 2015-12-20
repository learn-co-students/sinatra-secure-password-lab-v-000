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

  get "/error" do
    erb :error
  end

  post "/signup" do
    if params[:username] == "" || params[:username] == ""
      redirect "/error"
    else
      @user = User.new(username: params[:username], password: params[:password], balance: 0)
      @user.save
      redirect '/login'
    end
  end


  get "/login" do
    if logged_in?
      redirect "/success"
    else
      erb :login
    end
  end

  post "/login" do
    @user = User.find_by(username: params[:username])
    if @user && @user.authenticate(params[:password])
      session[:id] = @user[:id]
      redirect '/success'
    else
      redirect "/failure"
    end
  end

  get "/success" do
    @user = User.find_by_id(session[:user_id])
    if logged_in?
      erb :success
    else
      binding.pry
      redirect "/login"
    end
  end

  get "/dep_with" do 
    @user = User.find_by_id(session[:user_id])
    if logged_in?
      erb :dep_with
    else
      redirect "/login"
    end
  end

  post "/dep_with" do
    @user = User.find_by_id(session[:user_id])
    if logged_in?
      if (@user[:balance] + params[:deposit].to_i) > 0
        @user[:balance] += params[:deposit].to_i
        @user.save
      end
      binding.pry
      if params[:withdraw] != "" && (params[:withdraw].to_i - @user[:balance]) < 0
        @user[:balance] -= params[:withdraw].to_i
        @user.save
        redirect "/login"
      else
        binding.pry
        redirect "/login"
      end
    end
  end

  get "/failure" do
    erb :failure
  end

  get "/logout" do
    session.clear
    redirect "/"
  end


  private
  helpers do
    def logged_in?
      !!session[:id]
    end

    def current_user
      User.find(session[:id])
    end
  end
end
