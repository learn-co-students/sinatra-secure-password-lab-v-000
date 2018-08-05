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
    binding.pry  # doesn't hit
    # orig
    user = User.new(:username => params[:username], :password => params[:password])
    binding.pry # doesn't hit
    # user = User.create(:username => params[:username], :password => params[:password])
    # if user.valid?
    # if user.username
    #   user.save
    # end

#orig
    		# if user.save
    		# 	redirect "/login"
    		# else
    		# 	redirect "/failure"
    		# end

        # if user.username && user.save
    		# 	redirect "/login"
    		# else
    			redirect "/failure"
    		# end
        # user.username
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
    # orig
    # if user && user.authenticate(params[:password])
      # if user.username != nil && user.authenticate(params[:password])
        if user.username && user.authenticate(params[:password])
        session[:user_id] = user.id
      redirect "/success"
    else
      redirect "/failure"
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
