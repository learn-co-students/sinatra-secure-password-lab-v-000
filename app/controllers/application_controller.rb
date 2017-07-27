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
    if params[:username] == "" || params[:password] == ""
      redirect '/failure'
    elsif
      User.create(:username => params[:username], :password => params[:password])
      redirect '/login'
    end
  end

  get '/account' do
    @user = User.find(session[:user_id])
    erb :account
  end

  post '/account' do
    @user = User.find(session[:user_id])
    deposit = params[:deposit]
    withdrawal = params[:withdrawal]
    if deposit != ""
      @user.balance = @user.balance.to_f + deposit.to_f
      erb :new_account
    else
      if withdrawal.to_f > @user.balance.to_f
        erb :nsf
      else
        @user.balance = @user.balance.to_f - withdrawal.to_f
        redirect "/account"
      end
    end
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
