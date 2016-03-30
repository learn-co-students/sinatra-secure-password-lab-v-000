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
    user = User.new(params)
    if user.save
      session[:user_id] = user.id
      redirect '/login'
    else
      redirect 'failure'
    end

  end

  get '/account' do
    if !logged_in?
      redirect '/login'
    else
      @user = User.find(session[:user_id])
      erb :account
    end
  end

  post '/account' do
    @error = false
    @user = User.find(session[:user_id])
    # binding.pry
    bank_action = params.keys[0]
    if bank_action == "deposit"
      @user.balance += params[bank_action].to_f
      @user.save
      redirect '/account'
    elsif bank_action == "withdrawal"
      if @user.balance < params[bank_action].to_f
        @error = true
        erb :account
      else
        @user.balance -= params[bank_action].to_f
        @user.save
        redirect '/account'
      end
    end
  end


  get "/login" do
    erb :login
  end

  post "/login" do
    if params[:username] == "" || params[:password] == ""
      redirect '/failure'
    else
      user = User.find_by(username: params[:username])
      if user && user.authenticate(params[:password])
        session[:user_id] = user.id
        redirect '/account'
      else
        redirect '/failure'
      end
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
