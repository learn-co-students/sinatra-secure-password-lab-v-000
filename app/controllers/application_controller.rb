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
    if params[:username] == "" || params[:password] == ""
      redirect '/failure'
    else
      User.create(username: params[:username], password: params[:password])
      redirect '/login'
    end
  end

  get '/account' do
    @user = User.find(session[:user_id])
    erb :account
  end

  patch '/deposit' do
    amount = params[:deposit].to_f
    user = current_user
    if amount > 0
      user.balance += amount
      user.save
    end
    redirect '/account'
  end

  patch '/withdraw' do
    amount = params[:withdraw].to_f
    user = current_user
    if amount <= user.balance
      user.balance -= amount
      user.save
      redirect '/account'
    end
    redirect '/overdraft'
  end

  get "/login" do
    erb :login
  end

  get "/overdraft" do
    erb :overdraft
  end

  post "/login" do
    @user = User.find_by(username: params[:username])
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect '/account'
    else
      redirect '/failure'
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
