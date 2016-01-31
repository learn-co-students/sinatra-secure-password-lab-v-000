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

  get '/deposit' do
    if logged_in?
      erb :deposit
    else
      redirect "/login"
    end
  end

  get '/withdrawal' do
    if logged_in?
      erb :withdrawal
    else
      redirect "/login"
    end
  end

  post '/deposit' do
    amount = params[:deposit].to_i
    user = current_user
    user.update(balance: user.deposit(amount))
    erb :deposit
  end

  post '/withdrawal' do
    amount = params[:withdrawal].to_i
    user = current_user
    if user.balance >= amount
      user.update(balance: user.withdrawal(amount))
      erb :withdrawal
    else
      erb :withdrawal_error
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
