require "./config/environment"
require "./app/models/user"
class ApplicationController < Sinatra::Base

  configure do
    set :views, "app/views"
    enable :sessions
    set :session_secret, "password_security"
  end

  get "/" do
    erb :index #renders index
  end

  get "/signup" do
    erb :signup #renders signup form for a new user that include User and PW 
  end

  post "/signup" do
    #your code here
    user = User.new(:username => params[:username], :password => params[:password]) #creating the user 
    if user.save #save and is legit, login and go to accountpage
      redirect '/account'
    else 
      redirect '/failure'
    end
  end

  get '/account' do
    @user = User.find(session[:user_id])
    erb :account #renders and account page for the new user that just signed up
  end


  get "/login" do
    erb :login
  end

  post "/login" do
    ##your code here
    user = User.find_by(:username => params[:username])
      if user && user.authenticate(params[:password])
        session[:user_id] = user.id
        redirect '/account'
      else
        redirect 'failure'
      end
  end

  get "/failure" do
    erb :failure #renders if error occurs in signup
  end

  get "/logout" do
    session.clear
    redirect "/"
  end

  helpers do
    def logged_in?
      !!session[:user_id]#returns true or false based on the presence of a session[:user_id]
    end

    def current_user
      User.find(session[:user_id])#returns and instance of the logged in user, based on the session[:user_id]
    end
  end

end
