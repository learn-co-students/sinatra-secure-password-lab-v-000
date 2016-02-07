require 'pry'
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
    if params[:username].empty?
      redirect '/failure'
    else
      user = User.new(username: params[:username], password: params[:password])
      if user.save
        redirect '/login'
      else
        redirect '/failure'
      end
    end
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

  get "/account" do
    if logged_in?
      erb :account
    else
      redirect "/login"
    end
  end

  post '/deposit' do
    deposit
    redirect '/successful_deposit'
  end

  post '/withdraw' do
    if withdraw
      redirect '/successful_deposit'
    else
      erb :error
    end
  end

  get '/successful_deposit' do
    erb :successful_deposit
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
      !!session[:id]
    end

    def current_user
      User.find(session[:id])
    end

    def deposit
      current_user.update(:balance => params[:deposit].to_f)
      binding.pry
    end

    def withdraw
      transaction = false
      previous_balance = current_user.balance
      funds_to_withdraw = params[:withdraw].to_f
      calculation = previous_balance - funds_to_withdraw
      if calculation >= 0
        current_user.update(:balance => calculation)
        transaction = true
      end
      transaction
    end
  end

end
