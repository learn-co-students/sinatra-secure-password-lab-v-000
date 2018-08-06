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
        if params[:username] != "" && params[:password] != ""
    			redirect "/login"
    		else
    			redirect "/failure"
    		end
  end

  get '/account' do
    erb :account
  end


  get "/login" do
    erb :login
  end

  post "/login" do
      if params[:username] != "" && params[:password] != ""
        redirect to "/account"
    else
      redirect to "/failure"
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
