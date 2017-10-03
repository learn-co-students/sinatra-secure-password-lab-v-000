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
    #your code here

    redirect "/failure" if params[:username] == ""

    user = User.new(:username => params[:username], :password => params[:password])
    if  user.save #if it's savable under the has_secure_password macro
      redirect "/account"  #saves the user and redirect them to /login
    else
      redirect "/failure"
    end

  end

  get '/account' do
    @user = User.find(session[:user_id])
    erb :account
  end

  patch '/account' do #needs use Rack::MethodOverride in config.ru
    # binding.pry
    @user = User.find(session[:user_id])
    if params[:deposit]
      @user.balance = @user.balance.to_f + params[:deposit].to_f
    elsif params[:withdraw]
      if params[:withdraw].to_f > @user.balance
        redirect "/failure"
      else
        @user.balance = @user.balance.to_f - params[:withdraw].to_f
      end
    end
    @user.save
    redirect "/account"
  end

  get "/login" do
    erb :login
  end

  post "/login" do
    #params are from the get "/login" form
    user = User.find_by(:username => params[:username])
    if user && user.authenticate(params[:password])
      #sees if your scrambled pw matches.
      session[:user_id] = user.id
      redirect "/account"
    else
      redirect "/failure"
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
