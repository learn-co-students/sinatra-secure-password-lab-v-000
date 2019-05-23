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
    if params[:username] == "" || params[:password] == "" || params[:password] == nil
      redirect '/failure'
    else 
      @user = User.new
      @user.username = params[:username] 
      @user.password = params[:password] 
      @user.save
      
      redirect to '/login'
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
    if user = User.find_by(username: params["username"])
      session[:user_id] = user.id
      if user && user.authenticate(params[:password])
        redirect to '/account'
      else 
        redirect to '/failure'
      end
    else 
        redirect to '/failure'
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
