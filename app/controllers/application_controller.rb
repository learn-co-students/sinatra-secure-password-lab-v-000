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
    
    if (params[:username] != "") && (params[:password] != "")
      user = User.create(:username => params[:username], :password => params[:password])
      redirect "/login"
    else
      redirect "/failure"
    end
    # Code below doesn't account for blanks in Username or Password
    # user = User.new(:username => params[:username], :password => params[:password])
    #if user.save
    #  redirect "/login"
    #else
    #  redirect "/failure"
    #end
    
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
    # first find user
    # @user = User.find(session[:username]) # doesn't work properly
    # make sure password is correct
    # if it is, redirect to /account after assign session[user_id] from @user.user_id
    # if it isn't correct, redirect to failure
    # and use authenticate method for password checking
    @user = User.find_by(username: params[:username])
    if @user && @user.authenticate(params[:password]) # @user goes before @user.authenticate or it won't work
      # also params[:password] != "" doesn't work for some reason for an if condition
      session[:user_id] = @user.id
      redirect to "/account"
    else
      redirect to "/failure"
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
