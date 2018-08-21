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
    if params[:username]== "" || params[:password] === ""
      redirect '/failure'
    else
    user = User.new(username: params[:username], password: params[:password], balance: 0.00)


    user.save
      redirect '/login'

    end

  end

  get '/account' do
    @user = User.find_by(id: session[:id])

    erb :account
  end


  get "/login" do
    erb :login
  end

  post "/login" do
    user = User.find_by(username: params[:username])
    if user && user.authenticate(params[:password])
    session[:id] = user.id
    redirect '/account'
  else
    redirect '/failure'
  end
  end

  get "/failure" do
    erb :failure
  end

  post "/process" do
    @user = User.find_by(id: session[:id])
    @user.balance = @user.balance + params[:deposit].to_i
    if @user.balance >= params[:withdraw].to_i
      @user.balance = @user.balance - params[:withdraw].to_i
    else
      redirect '/insufficient'
    end
    @user.save

    redirect '/account'
  end

  get '/insufficient' do
    erb :insufficient
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
