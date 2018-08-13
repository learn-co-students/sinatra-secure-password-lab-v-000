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
    redirect '/failure' if !validate_username(params[:username]) #|| !!User.find_by(username: params[:username]) 
    @user = User.new(username: params[:username], password: params[:password], balance: 0)
    if !!@user.save
      # session[:user_id] = @user.id
      redirect '/login'
    else
      redirect '/failure'
    end
  end

  get '/account' do
    redirect '/' if !logged_in?
    @user = current_user
    erb :account
  end


  get "/login" do
    erb :login
  end

  post "/login" do
    @user = User.find_by(username: params[:username]).try(:authenticate, params[:password])
    if !!@user
      session[:user_id] = @user.id
      redirect '/account'
    else
      redirect '/failure'
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

    def validate_username(un)
      un.length > 0
    end
  end

end
