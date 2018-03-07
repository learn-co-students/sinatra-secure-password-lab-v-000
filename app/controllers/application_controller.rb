require "./config/environment"
require "./app/models/user"
class ApplicationController < Sinatra::Base
  #==================== CONFIGURATION =====================
  configure do
    set :views, "app/views"
    enable :sessions
    set :session_secret, "password_security"
  end
  #--------------------------------------------------------


  #==================== SIGNUP ============================
  get "/" do
    erb :index
  end
  
  get "/signup" do
    erb :signup
  end
  
  post "/signup" do
    user = User.new(:username => params[:username], :password => params[:password])
    (user.username != "" && user.save) ? (redirect "/login") : (redirect "/failure")
  end
  #--------------------------------------------------------


  #==================== LOG IN ============================
  
  get "/login" do
    erb :login
  end
  
  post "/login" do
    user = User.find_by(:username => params[:username])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect "/account"
    else
      redirect "/failure"
    end  
  end
  #--------------------------------------------------------
  
  
  #================== REDIRECTS & LOGOUT ==================
  get '/account' do
    @user = User.find(session[:user_id])
    erb :account
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
  #--------------------------------------------------------


  #==================== HELPERS ===========================
  helpers do
    def logged_in?
      !!session[:user_id]
    end
    
    def current_user
      User.find(session[:user_id])
    end
  end
  #--------------------------------------------------------

end
