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
    @user = User.new(:username => params[:username], :password => params[:password], :balance => 0)
    if params[:password] == ""
      redirect '/failure'
    elsif params[:username] == ""
      redirect '/failure'
    else
      if @user.save
	        redirect "/login"
	    else
	        redirect "/failure"
	    end
    end
	end

  get '/account' do
    @user = User.find(session[:user_id])
    erb :account
  end

  patch '/account' do
    @user = User.find(session[:user_id])
    number = math(@user.balance, params[:deposit], params[:withdraw])
    if number >= 0
      @user.balance = number
      @user.save
      redirect '/account'
    else
      redirect '/account?error=You do not have enough to withdraw this amount'
    end
  end


  get "/login" do
    erb :login
  end

  post "/login" do
    ##your code here
    if @user = User.find_by(:username => params[:username])

      if @user && @user.authenticate(params[:password])
        session[:user_id] = @user.id
        redirect "/account"
      else
        redirect "/failure"
      end
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

    def math(start, add = 0, subtract = 0)
      value = start.to_f + add.to_f
      value -= subtract.to_f
      return value
    end
  end

end
