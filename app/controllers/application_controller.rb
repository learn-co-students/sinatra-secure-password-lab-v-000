require "./config/environment"
require "./app/models/user"
require 'pry'
require 'bcrypt'
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
    #@user = User.new(username: params[:username], password: params[:password])
      #if user.save

      if params["username"] == "" || params["password"] == ""
        redirect "/failure"
      else
        #@user.save
        #@session[user_id] = user.id
        redirect '/login'
      end
  end

  get '/account' do
    #@user = User.find_by(session[:user_id])
    erb :account
  end


  get "/login" do
    erb :login
  end

  post "/login" do
    user = User.find_by(username: params[:username])
    #binding.pry
    if !!user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect "/account"
    else
    redirect "/failure"
    end
end
    #binding.pry
    #!!user ? (session[:user_id] = user.id) && (redirect '/account') : (redirect '/failure')



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
