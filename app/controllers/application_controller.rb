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
    user = User.new(username: params[:username], password: params[:password])
    if user.save
      redirect '/login'
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
    user = User.find_by(username: params[:username])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect '/account'
    else
      redirect 'failure'
    end
  end

  get "/account" do
    if logged_in?
      erb :account
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

  post '/deposit' do
    user = User.find_by(id: session[:user_id])
    if user
      new_balance = user.balance += params[:deposit_amount].to_f
      user.update(balance: new_balance)
    end
    redirect '/account'
  end

  post '/withdraw' do
    user = User.find_by(id: session[:user_id])
    if user && user.balance >= params[:withdraw_amount].to_f
      new_balance = user.balance -= params[:withdraw_amount].to_f
      user.update(balance: new_balance)
    else
      redirect '/failure'
    end
    redirect '/account'
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
