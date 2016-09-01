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
    # user = User.new(:username => params[:username], :password => params[:password])
    # if user.save
    #   redirect '/login'
    # else
    #   redirect '/failure'
    # end

    if params[:username] == "" || params[:password] == ""
      redirect '/failure'
    else
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
    if params[:username] == "" || params[:password] == ""
      redirect '/failure'
    else
      @user = User.find_by(username: params[:username])
      session[:user_id] = @user.id
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

  get "/failure" do
    erb :failure
  end

  get "/logout" do
    session.clear
    redirect "/"
  end

  get '/deposit' do
    erb :deposit
  end

  post '/deposit' do
    deposit
    erb :account
  end

  get '/withdrawal' do
    erb :withdrawal
  end

  post '/withdrawal' do
    withdrawal
    erb :account
  end

  helpers do
    def logged_in?
      !!session[:user_id]
    end

    def current_user
      User.find(session[:user_id])
    end

    def deposit
      @user = current_user
      amount = params[:amount].to_f
      balance = @user.balance.to_f
      balance += amount
      @user.balance = balance
      @user.save
    end

    # this code smells
    def withdrawal
      @user = current_user
      amount = params[:amount].to_f
      balance = @user.balance.to_f
      if amount <= balance
        balance -= amount
      else
        redirect '/failure'
      end
      @user.balance = balance
      @user.save
    end
  end

end
