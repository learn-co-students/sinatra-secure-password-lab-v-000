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
    #your code here
    user = User.new(params)
    if user.save
      redirect '/login'
    else
      redirect '/failure'
    end
  end

  get '/account' do
    # binding.pry
    @user = User.find_by_id(session[:user_id])
    erb :account
  end

  patch '/account' do
    @user = User.find_by_id(session[:user_id])
    # binding.pry
    if @user[:balance] + params[:deposit_amount].to_i - params[:withdrawal_amount].to_i < 0
      redirect '/no_money'
    else
      @user.increment!(:balance, by = params[:deposit_amount].to_i)
      @user.decrement!(:balance, by = params[:withdrawal_amount].to_i)
      redirect '/account'
    end
  end

  get '/no_money' do
    erb :no_money
  end

  get "/login" do
    erb :login
  end

  post "/login" do
    ##your code here
    user = User.find_by(username: params[:username])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
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
