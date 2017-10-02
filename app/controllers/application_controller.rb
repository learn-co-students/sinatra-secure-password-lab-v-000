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
    require 'pry'
    @user = User.new(username: params[:username], password: params[:password])
    if @user.username == "" || @user.username == nil
      redirect '/failure'
    elsif @user.password == "" || @user.password == nil
      redirect '/failure'
    end

    if @user.save
      session[:user_id] = @user.id
      redirect '/login'
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
    if params[:username] == "" || params[:password] == ""
      redirect '/failure'
    else
      @user = User.find_by(username: params[:username])
      if @user && @user.authenticate(params[:password])
        session[:user_id] = @user.id
        redirect '/success'
      else
        redirect '/failure'
      end
    end
  end

  get "/success" do
    if logged_in?
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
