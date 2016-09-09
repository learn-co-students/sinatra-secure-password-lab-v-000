require "./config/environment"
require "./app/models/user"
require 'pry'
class ApplicationController < Sinatra::Base

  configure do
    set :views, "app/views"
    enable :sessions
    set :session_secret, "password_security"
  end

  get "/" do
    if logged_in?
      redirect '/account'
    else
      erb :index
    end
  end

  get "/signup" do
    erb :signup
  end

  post "/signup" do
    #your code here
    if params[:username].empty? || params[:password].empty?
      redirect '/failure'
    else
      user = User.create(:username => params[:username], :password => params[:password])
      redirect '/login'
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
    ##your code here
    user = User.find_by(:username => params[:username])

    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
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

  get '/transfer' do
    @user = User.find(session[:user_id])
    erb :transfer
  end

  post '/deposit' do
    @user = User.find(session[:user_id])
    @deposit = params[:deposit].to_f
    @user.balance = @user.balance + @deposit
    @user.save
    erb :completed_deposit
  end

  post '/withdrawal' do
    @user = User.find(session[:user_id])
    @withdrawal = params[:withdrawal].to_f
    if @withdrawal > @user.balance
      redirect '/failure'
    else
      @user.balance = @user.balance - @withdrawal
      @user.save
      erb :completed_withdrawal
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
