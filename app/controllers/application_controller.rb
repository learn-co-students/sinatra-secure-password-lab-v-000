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
    puts params
    @user = User.new(username: params["username"], password: params["password"])
    if  params ([:username][:password]) == ""
    redirect to "/failure"

    # In a post request, I should be re-directing, not rendering. will need if statement possibly failure.erb
    else
      @user.save
      session[:user_id] = @user.id
      redirect to "/signup"
      end
    end
# Don;t forget to pry and use params

  get "/account" do
    @user = User.find(session[:user_id])
    erb :account
  end


  get "/login" do
    erb :login
  end


  post "/login" do
    @user = User.find_by(:username => params[:username], password: params[:password])
    session[:user_id] = @user.id
        if @user != nil && @user.password.authenticate(params[:password]) == params[:password]
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
