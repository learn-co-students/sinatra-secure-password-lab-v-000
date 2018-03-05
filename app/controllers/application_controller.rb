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

    if user.save then redirect "/login" else redirect "/failure" end
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
      session[:user_id] = user.id
      redirect "/account"
    else
      redirect "/failure"
    end
  end

  get "/success" do
    if logged_in? then erb :success else redirect "/login" end
  end

  get "/failure" do
    erb :failure
  end

  get "/logout" do
    session.clear
    redirect "/"
  end

  get "/deposit" do
    erb :deposit
  end

  post "/deposit" do
    user = User.find(session[:user_id])

    user.balance += params[:deposit].to_i
    user.save
    redirect "/account"
  end

  get "/withdrawal" do
    user = User.find(session[:user_id])

    if logged_in? then erb :withdrawal else erb :insufficient_funds end
  end

  post "/withdrawal" do
    user = User.find(session[:user_id])

    if user && user.balance >= params[:withdrawal].to_i
      user.balance -= params[:withdrawal].to_i
      user.save
      redirect "/account"
    else
      erb :insufficient_funds
    end
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
