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
    if params[:username] != "" && params[:password] != ""
      user = User.new(username: params[:username], password: params[:password], balance: 0)
      user.save
      redirect "/login"
    else
      redirect "/failure"
    end
  end

  get '/account' do
    @user = User.find(session[:user_id])
    erb :account
  end

  get '/deposit' do
    erb :deposit
  end

  post '/deposit' do
    @user = User.find(session[:user_id])
    User.update(session[:user_id], balance: @user.balance.to_i + params[:sum].to_i)
    redirect '/success'
  end

  get '/withdraw' do
    erb :withdraw
  end

  post '/withdraw' do
    @user = User.find(session[:user_id])
    if @user.balance >= params[:sum].to_f
      User.update(session[:user_id], balance: @user.balance - params[:sum].to_f)
      redirect '/success'
    else
      session[:error] = "You don't have enough funds for this operation, sucker."
      redirect '/failure'
    end
  end

  post '/success' do
    
    erb :success
  end

  get "/login" do
    erb :login
  end

  post "/login" do
    user = User.find_by(username: params[:username])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
       redirect '/account'
     else
      session[:error] = "Wrong password or username"
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
    if session
      @error = session[:error]
    end
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

