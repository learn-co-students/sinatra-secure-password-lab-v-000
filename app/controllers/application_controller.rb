require "./config/environment"
require "./app/models/user"
#========================================================== 
class ApplicationController < Sinatra::Base
#==========================CONFIG========================== 
  configure do
    set :views, "app/views"
    enable :sessions
    set :session_secret, "password_security"
  end
#==========================ROUTES========================== 
#----------------------------------------------------home-# 
  get "/" do
    erb :index
  end
#==========================SIGNUP========================== 
  get "/signup" do
    erb :signup
  end

	post "/signup" do 
#------------------------------------------if-empty-field-# 
    if params.values.any?{|v| v.empty?}  
      redirect '/failure'
#---------------------------------------------if-new-user-# 
    elsif User.find_by(username: params[:username]).nil?
      User.create(params)
      redirect '/login'
#----------------------------------------if-existing-user-# 
    else
      # extra practice checking if user exists
      redirect '/existing'
    end
	end
#==========================LOGIN=========================== 
  get "/login" do
    erb :login
  end

  post "/login" do 
    @user = User.find_by(username: params[:username])
#--------------------------------------if-exists-and-auth-# 
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect to "/account"
#----------------------------------------------if-no-user-# 
    else
      redirect to "/failure"
    end
  end
#======================ACCOUNT PAGE======================== 
  get '/account' do
    @user = User.find(session[:user_id])
    erb :account
  end
#--------------------------------------------transactions-# 
  post "/transactions" do
    @user = User.find(session[:user_id])
#------------------------------------------------deposits-# 
    if !params[:deposit].empty?
      @user.balance += params[:deposit].to_f
      @user.save
      erb :account
#----------------------------------------------withdrawal-# 
    elsif !params[:withdrawal].empty?
      @user.balance -= params[:withdrawal].to_f
      @user.save
      erb :account
    end
  end 
#=========================ERRORS=========================== 
#------------------------------------------------existing-# 
	get "/existing" do
    erb :exists
  end
#-------------------------------------------------failure-# 
  get "/failure" do
    erb :failure
  end
#=========================LOGOUT=========================== 
  get "/logout" do
    session.clear
    redirect "/"
  end
#========================HELPERS=========================== 
#-----------------------------------------------logged-in-# 
  helpers do
    def logged_in?
      !!session[:user_id]
    end
#--------------------------------------------current-user-# 
    def current_user
      User.find(session[:user_id])
    end
  end
#========================================================== 
end
