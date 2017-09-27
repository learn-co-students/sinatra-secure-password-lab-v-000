require "./config/environment"
require "./app/models/user"
require 'rack-flash'
class ApplicationController < Sinatra::Base

  configure do
    set :views, "app/views"
    enable :sessions
    set :session_secret, "password_security"
  end
  use Rack::Flash

  get "/" do
    erb :index
  end

  get "/signup" do
    erb :signup
  end

  post "/signup" do
    if params[:username].empty? || params[:password].empty?
      redirect '/failure'
    else
      user = User.new(username: params[:username],
                       password: params[:password])
      user.save
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
    user = User.find_by(username: params[:username])

    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect '/account'
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

  get "/deposit" do
    @user = User.find(session[:user_id])

    erb :deposit
  end

  post '/deposit' do
    @user = User.find(session[:user_id])

    depo = params[:depo_amount].to_i
    @user.deposit(depo)

    flash[:message] = "The deposited of $#{params[:depo_amount]} was successful."

    erb :account
  end

  get "/withdrawal" do
    @user = User.find(session[:user_id])

    erb :withdrawal
  end

  post '/withdrawal' do
    @user = User.find(session[:user_id])

    withdrawal = params[:withdrawal_amount].to_i

    if withdrawal > @user.balance
      flash[:message] = "Transaction could not be processed."
      erb :account
    else
      flash[:message] = "The withdrawal of $#{params[:withdrawal_amount]} was successful."
      @user.withdrawal(withdrawal)
      erb :account
    end
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
