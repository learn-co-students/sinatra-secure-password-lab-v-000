require "./config/environment"
require "./app/models/user"
class ApplicationController < Sinatra::Base

  configure do
    set :views, "app/views"
    enable :sessions
    set :session_secret, "password_security"
  end

  #Renders Index page
  get "/" do
    erb :index
  end

  #Renders signup page
  get "/signup" do
    erb :signup
  end

  #Creates a new "User" instance and redirects to login page, after signing up
  post "/signup" do
    user = User.new(username: params[:username], password: params[:password], balance: 0)
    if user.save
      redirect '/login'
    else
      redirect '/failure'
    end
  end

  #Renders the account page if the user is logged in
  get '/account' do
    if !logged_in?
      redirect '/login'
    else
      @user = User.find(session[:user_id])
      erb :account
    end
  end

  #Renders log in page
  get "/login" do
    erb :login
  end

  #Redirects to account page if log in is successful
  post "/login" do
    @user = User.find_by(username: params[:username])
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect '/account'
    else
      redirect '/failure'
    end
  end

  #Processes deposit, and redirects to account page
  post '/deposit' do
    @user = current_user
    @user.balance += params[:deposit].to_i
    @user.save
    #binding.pry
    redirect '/account'
  end

  #Processes withdrawal if valid, and redirects to account page, gives an error if insufficient balance
  post '/withdrawal' do
    @user = current_user
    @insuf_bal = false
    if @user.balance < params[:withdrawal].to_i
      @insuf_bal = true
      erb :account
    else
      @user.balance -= params[:withdrawal].to_i
      @user.save
      redirect '/account'
    end
  end

  get "/success" do
    if logged_in?
      erb :success
    else
      redirect "/login"
    end
  end

  #Renders failure page
  get "/failure" do
    erb :failure
  end

  #Clears session and logs the user out
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
