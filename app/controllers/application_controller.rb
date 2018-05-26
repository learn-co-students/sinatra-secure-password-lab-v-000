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

   if !params[:username].empty? && user.save
       redirect "/login"
   else
       redirect "/failure"
   end

  end

  get '/account' do
    if logged_in?
      @user = current_user
      erb :account
    else
      redirect '/failure'
    end
  end

  post "/account" do
    @user = current_user
    if !!params[:deposit]
      deposit_amount = params[:deposit]
      @user.balance += deposit_amount.to_f
      @user.save
    elsif !!params[:withdrawl]
      withdrawl_amount = params[:withdrawl].to_f
      @user.save
      if withdrawl_amount > @user.balance
        redirect "/error"
      else
        @user.balance  -= withdrawl_amount
        @user.save
      end
    end

    erb :account
  end

  get "/error" do
    erb :error
  end
  get "/deposit" do
    erb :deposit
  end

  get "/withdrawl" do
    erb :withdrawl
  end

  get "/login" do
    erb :login
  end

  post "/login" do
    if !params[:username].empty? && !params[:password].empty?
      user = User.find_by(username: params[:username])
      if user && user.authenticate(params[:password])
        session[:user_id] = user.id
        redirect "/account"
      else
        redirect '/failure'
      end
    else
      redirect "/failure"
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
