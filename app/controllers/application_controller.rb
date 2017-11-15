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
    #your code here
    user = User.new(:username => params[:username], :password => params[:password], :balance => 0)

    if user.save && user[:username].size > 0
        redirect "/login"
    else
        redirect "/failure"
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
    ##your code here
    user = User.find_by(:username => params[:username])
		if user && user.authenticate(params[:password])
        session[:user_id] = user.id
        #binding.pry
        redirect "/account"

    else
        redirect "/failure"
    end
  end

  get "/account" do
    if logged_in?
      erb :account
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

  post "/deposit" do
    user = current_user
    user[:balance] += params[":deposit"].to_f
    user.save
    redirect "/account"
  end

  post "/withdrawl" do
    user = current_user
    if user[:balance] > params[":withdrawl"].to_f
        user[:balance] -= params[":withdrawl"].to_f
        user.save
        redirect "/account"
    else
      redirect "/account"
    end
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
