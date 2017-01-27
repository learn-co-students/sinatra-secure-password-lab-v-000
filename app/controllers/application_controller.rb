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
    if params[:username] == "" || params[:password] == ""
      redirect "/failure"
		else
			redirect "/login"
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
			redirect "/account"
		else
			redirect "/failure"
		end
  end

  post '/deposit' do
    @user = current_user
    @user.balance += params[:deposit].to_i
    @user.save
    redirect '/account'
  end

  post '/withdrawal' do
    @user = current_user
    @insufficient_funds = false
    if @user.balance < params[:withdrawal].to_i
      @insufficient_funds = true
      erb :account
    else
      @user.balance -= params[:withdrawal].to_i
      @user.save
      redirect '/account'
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
