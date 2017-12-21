require "./config/environment"
require "./app/models/user"
require 'pry'
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
    if params[:username] == "" || params[:password] == ""
			redirect "/failure"
		else 
		  user = User.new(:username => params[:username], :password => params[:password])
		  user.save 
		  #binding.pry
		  redirect "/login"
		end 

  end

  get '/account' do
    #binding.pry
    @user = User.find(session[:user_id])
    erb :account
  end


  get "/login" do
    erb :login
  end

  post "/login" do
    ##your code here
    
    if  params[:username] == "" || params[:password] == ""
      #binding.pry
			redirect "/failure"
		else 
		   user = User.find_by(:username => params[:username])
      user.password = params[:password]
      user.password_confirmation = params[:password]
		end 
		
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id 
		  redirect "/account"
		else 
		  redirect "/failure"
		end 
      
=begin       
     if  params[:username] == "" || params[:password] == ""
      #binding.pry
			redirect "/failure"
		elsif  
		  
		  #binding.pry
		  session[:user_id] = user.id 
		  redirect "/account"
		end 
=end 
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
