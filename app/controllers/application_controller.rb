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
    if params[:username].size > 0
      user = User.new(:username => params[:username], :password => params[:password], :balance => 0)
      if user.save
        redirect "/login"
      else
        redirect "/failure"
      end
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
    user = User.find_by(:username => params[:username])
    if user && user.authenticate(params[:password])
      @user = user
      session[:user_id] = user.id
      redirect "/account"
    else
      redirect "/failure"
    end
  end
  
  get "/deposit" do
    @user = User.find(session[:user_id])
    erb :deposit
  end

  get "/withdrawal" do    
    @user = User.find_by(:id => session[:user_id])
    erb :withdrawal
  end

  post "/deposit" do
    @user = User.find(session[:user_id])
    @user[:balance]+= params[:deposit].to_f
    User.update(session[:user_id], :balance => @user[:balance])
    redirect "/account"
  end

  post "/withdrawal" do    
    @user = User.find(session[:user_id])
    if @user[:balance] > params[:withdrawal].to_f
      @user[:balance]-= params[:withdrawal].to_f
      User.update(session[:user_id], :balance => @user[:balance])
      redirect "/account" 
    else
       @message = "You have insufficient funds to cover that withdrawal"
       puts @message
       redirect "/account"
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
