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
    if params[:username].empty? || params[:password].empty?
      redirect "/failure"
    end
    user = User.new(:username => params[:username], :password => params[:password])
  	if user.save
  		redirect "/login"
  	else
  		redirect "/failure"
  	end
  end

  get '/account' do
    binding.pry
    @user = User.find(session[:user_id])
    erb :account
  end


  get "/login" do
    erb :login
  end

  post "/login" do
    @current_user = User.find_by(:username => params[:username])
    if @current_user && @current_user.authenticate(params[:password])
        session[:user_id] = @current_user.id
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
