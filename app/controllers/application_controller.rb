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
    erb :index
  end

  get "/signup" do
    erb :signup
  end

  post "/signup" do
    if filled_out(params)
      User.create(username: params[:username], password: params[:password])
      redirect to '/login'
    else
      redirect to '/failure'
    end
    binding.pry
  end

  get '/account' do
    @user = current_user
    erb :account
  end

  get '/account/deposit' do
    @user = current_user
    erb :deposit
  end

  post '/account/deposit' do
    @user = current_user
    @user.balance += params[:deposit_amount].to_f
    @user.save
    redirect to '/account'
  end

  get '/account/withdraw' do
    # binding.pry
    @user = current_user
    erb :withdraw
  end

  post '/account/withdraw' do
    @user = current_user
    if @user.balance > params[:withdraw_amount].to_f
      @user.balance -= params[:withdraw_amount].to_f
      @user.save
      # binding.pry
      redirect to '/account'
    else
      redirect to '/failure'
    end

  end



  get "/login" do
    erb :login
  end

  post "/login" do
    ##your code here
    # binding.pry
    user = User.find_by(username: params[:username])
    if user && user.authenticate(params[:password])

      #binding.pry
      session[:user_id] = user.id
      redirect to '/account'
    else
      redirect to '/failure'
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

    def filled_out(params)
      if params[:password] == "" || params[:username] == ""
        false
      else
        true
      end
    end
  end
end
