require "./config/environment"
require "./app/models/user"
<<<<<<< HEAD
require 'pry'
=======
require "pry"
>>>>>>> d9694297b98a225c827e47462c26e556790b9255
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
<<<<<<< HEAD
    if params[:username] == "" || params[:password] == ""
      redirect '/failure'
    else
      User.create(params)
      redirect '/login'
    end

=======
    user = User.new(:username => params[:username], :password => params[:password])
    if user.save
      redirect "/login"
    else
      redirect "/failure"
    end
>>>>>>> d9694297b98a225c827e47462c26e556790b9255
  end

  get '/account' do
    @user = User.find(session[:user_id])
    erb :account
  end


  get "/login" do
    erb :login
  end

  post "/login" do
<<<<<<< HEAD
    @user = User.find_by(username: params[:username])
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect "/account"
    else
      redirect '/failure'
=======
    user = User.find_by(username: params[:username], password: params[:password])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id 
      redirect "/success"
    else
      redirect "/failure"
>>>>>>> d9694297b98a225c827e47462c26e556790b9255
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
