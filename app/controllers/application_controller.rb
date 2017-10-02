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
    #your code here
    user = User.new(username: params[:username], password: params[:password], balance: 0.00)
    if user.save
      redirect to '/login'
    else
      redirect to '/failure'
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
    ##your code here
    user = User.find_by(username: params[:username])

    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect "/account"
    else
      redirect 'failure'
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

  get "/deposit" do
    if logged_in?
      erb :deposit
    else
      redirect "/login"
    end
  end

  get "/withdraw" do
    if logged_in?
      erb :withdraw
    else
      redirect "/login"
    end
  end

  post '/deposit' do
    if params[:deposit].to_f > 0
      current_user.update(balance: current_user.balance + params[:deposit].to_f)
      redirect to '/account'
    else
      redirect to '/failure'
    end
  end

  post '/withdraw' do
    if params[:withdraw].to_f > 0 && params[:withdraw].to_f <= current_user.balance
      current_user.update(balance: current_user.balance - params[:withdraw].to_f)
      redirect to '/account'
    else
      redirect to '/failure'
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
