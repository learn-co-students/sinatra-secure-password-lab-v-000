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
    user = User.new(username: params[:username], password: params[:password], balance: 0)
    if user.save
      redirect '/login'
    else
      redirect '/failure'
    end
  end


  get "/login" do
    erb :login
  end

  post "/login" do
    user = User.find_by(username: params[:username])
    if user && user.authenticate(params[:password])
      session[:id] = user.id
      redirect '/success'
    else
      redirect '/failure'
    end
  end

  get "/success" do
    if logged_in?
      @user = User.find(session[:id])
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

  patch '/withdraw' do
    if logged_in?
      user = User.find(session[:id])
      if params[:withdraw_amount].to_f <= user.balance
        user.balance -= params[:withdraw_amount].to_f
        user.save
        redirect "/success"
      else
        "Not enough funds"
      end
    else
      redirect "/login"
    end
  end

  patch '/deposit' do
    if logged_in?
      user = User.find(session[:id])
      user.balance += params[:deposit_amount].to_f
      user.save
      redirect "/success"
    else
      redirect "/login"
    end
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
