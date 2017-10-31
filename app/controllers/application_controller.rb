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
    if params[:username]== "" || params[:password]== ""
      redirect '/failure'
    else
      user = User.create(username: params[:username], password: params[:password])
      session[:user_id]=user.id

      #your code here
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
    @user = User.find_by(username: params[:username])
      if @user && @user.authenticate(params[:password])
        session[:user_id] = @user.id
        redirect to "/account"
      else
        redirect to "/failure"
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

  post '/addmoney' do
    @user = User.find(session[:user_id])
    @user.balance+=params[:balance].to_i
    @user.save
    redirect '/account'
  end

  post '/removemoney' do
    @user = User.find(session[:user_id])
    if @user.balance > params[:balance].to_i
      @user.balance-=params[:balance].to_i
      @user.save
      redirect '/account'
    else
      redirect '/account'
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
