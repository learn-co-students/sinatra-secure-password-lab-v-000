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
    user = User.new(:username => params[:username], :password => params[:password])

    if user.save
      redirect '/account'
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
    user = User.find_by(:username => params[:username])

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

  get '/withdraw' do
    @user = User.find(session[:user_id])
    erb :withdraw
  end

  post '/withdraw' do
    if logged_in?
      user = current_user
      amount = params[:withdraw].to_f
      if logged_in? && user.balance > amount
        user.update(balance: user.balance - amount)
        redirect '/account'
      else
        redirect '/withdraw'
      end
    else
      redirect '/failure'
    end
  end

  get '/deposit' do
    @user = User.find(session[:user_id])
    erb :deposit
  end

  post '/deposit' do
    if logged_in?
      user = current_user
      ammount = params[:deposit].to_f
      user.update(balance: user.balance + amount)
      redirect '/account'
    else
      redirect '/failure'
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
