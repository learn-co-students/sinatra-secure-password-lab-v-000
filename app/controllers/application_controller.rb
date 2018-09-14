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
    user = User.new(:username => params[:username], :password => params[:password])
    binding.pry
    if params[:username].blank? || params[:password].blank?
      redirect '/failure'
    elsif user.save
      session[:user_id] = params[:password]
      redirect '/account'
    end

    # if params[:username].blank? || params[:password].blank? || !user.save
    #   redirect '/failure'
    # elsif user.save
    #   session[:user_id] = params[:password]
    #   redirect '/account'
    # end
  end

  get '/account' do
    if logged_in?
      @user = User.find(session[:user_id])
      erb :account
    else
      redirect '/failure'
    end
  end


  get "/login" do
    erb :login
  end

  post "/login" do
    user = User.find_by(:username => params[:username])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect '/account'
    else
      redirect '/failure'
    end

    # user = User.find_by(:username => params[:username])
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
