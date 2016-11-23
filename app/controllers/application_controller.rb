require './config/environment'
require './app/models/user'
require 'pry'
class ApplicationController < Sinatra::Base

  configure do
    set :views, 'app/views'
    enable :sessions
    set :session_secret, 'password_security'
  end

  get '/' do
    erb :index
  end

  get '/signup' do
    erb :signup
  end

  post '/signup' do
    user = User.new(:username => params[:username], :password => params[:password])
    user.balance = 0
    if
      params[:username] == ""
      redirect '/failure'
    elsif
      !user.save
      redirect '/failure'
    else
      user.save
      redirect '/login'
    end
  end

  get '/login' do
    erb :login
  end

  post '/login' do
    @user = User.find_by(username: params[:username])
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect '/account'
    else
      redirect '/failure'
    end
  end

  get '/success' do
     if logged_in?
       erb :success
     else
       redirect '/failure'
     end
   end

  get '/account' do
    @user = current_user
    erb :account
  end

  post '/account' do
    @user = current_user
    @bal = @user.balance
    @wd = params[:withdrawal].to_i
    @dep = params[:deposit].to_i
    if @wd > 0
      @bal = @bal - @wd unless @wd > @bal
      @user.save
    elsif @dep > 0
      @bal = @bal + @dep
    end
    @user.balance = @bal
    @user.save
    erb :account
  end

  get '/failure' do
    erb :failure
  end

  get '/logout' do
    session.clear
    redirect '/'
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
