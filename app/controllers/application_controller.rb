require "./config/environment"
require "./app/models/user"
require "pry"
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
    else
      user = User.create(username: params[:username], password: params[:password])
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
    @user = User.find_by(username: params[:username])
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect '/account'
    else
      redirect '/failure'
    end
  end

  get '/transaction' do
    erb :transaction if current_user
  end

  post '/transaction' do
    @user = current_user
    @deposit = params[:deposit].to_f
    @withdrawal = params[:withdrawal].to_f
    if @deposit != 0
      updated = @user.balance += @deposit
      @user.update(balance: updated)
      erb :show_transaction
    elsif @withdrawal != 0
      if (@user.balance - @withdrawal) >= 0
        updated = @user.balance -= @withdrawal
        @user.update(balance: updated)
        erb :show_transaction
      else
        erb :transaction
      end
    else
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

  helpers do
    def logged_in?
      !!session[:user_id]
    end

    def current_user
      User.find(session[:user_id])
    end
  end

end
