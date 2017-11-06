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
    if params[:username] == ""
      redirect "/failure"
    elsif params[:password] == nil
      redirect "/failure"
    else
      user = User.new(username: params[:username], password: params[:password])

      if user.save
        session[:user_id] = user.id
        redirect '/login'
      else
        redirect "/failure"
      end
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
    if params[:username] == ""
      redirect "/failure"
    elsif params[:password] == ""
      redirect "/failure"
    else
      @user = User.find_by(username: params[:username])
      session[:user_id] = @user.id
      redirect "/account"
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
