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
    user = User.new(username: params[:username], password: params[:password])

    if user.save && user.username != "" 
      redirect '/login'
    else
      redirect '/failure'
    end
  end

  get '/account' do
    @user = User.find(session[:user_id])
    erb :account
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
      redirect '/failure'
    end
  end

  get "/account" do
    if logged_in?
      erb :account
    else
      redirect "/login"
    end
  end

  post '/deposit' do
    @user = User.find(session[:user_id])
    deposit_amt = sprintf("%.2f", params[:deposit])
    @user.deposit(deposit_amt)
    @user.save

    redirect '/account'
  end

  post '/withdrawal' do
    @user = User.find(session[:user_id])
    if @user.balance > params[:withdrawal].to_i
      @user.withdrawal(params[:withdrawal])
      @user.save

      redirect '/account'
    else 
      redirect '/failure'
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
