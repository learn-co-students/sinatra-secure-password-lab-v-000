require './config/environment'
require './app/models/user'
class ApplicationController < Sinatra::Base

  configure do
    set :views, 'app/views/'
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
    if params[:username] == '' || params[:password] == ''
      redirect '/failure'
    else
      @user = User.new(:username => params[:username], :password => params[:password])
      @user.save
      redirect '/login'
    end
  end

  get '/login' do
    erb :login
  end

   post '/login' do
    @user =  User.find_by(:username => params[:username])
   if params[:username] == "" || params[:password] == ""
      redirect '/failure'
    else
      session[:id] = @user.id
      redirect '/account'
    end
  end

  get '/account' do
    if logged_in?
      @user = User.find_by(session[:id])
      erb :account
    else
      redirect '/login'
    end
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
      !!session[:id]
    end

    def current_user
      User.find(session[:id])
    end
  end
end
