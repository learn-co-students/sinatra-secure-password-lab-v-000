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
    if params[:username] != "" && params[:password] != ""
      User.create(params)
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
      @user = current_user
      erb :account
    else
      redirect "/login"
    end
  end

  get "/failure" do
    erb :failure
  end

  get '/deposit' do
    erb :deposit
  end

  post '/deposit' do
    user = current_user
    user.balance += (params[:amount].to_i)*100
    user.save
    redirect '/success'
  end

  get '/withdraw' do
    erb :withdraw
  end

  post '/withdraw' do
    if valid_withdrawal?
      user = current_user
      user.balance -= (params[:amount].to_i)*100
      user.save
      redirect '/success'
    else
      erb :invalid
    end
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

    def valid_withdrawal?
      current_user.balance > (params[:amount].to_i)*100 ? true : false
    end
  end

end
