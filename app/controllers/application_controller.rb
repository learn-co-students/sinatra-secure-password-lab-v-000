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
      user = User.create(username:params[:username], password:params[:password],balance: 0)
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
    user = User.find_by(username:params[:username])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect to '/account'
    else
      redirect to '/failure'
    end
  end

  post "/deposit" do
    if Float(params[:deposit]) > 0
      current_user.update(balance:current_user.deposit(params[:deposit]))
      redirect to '/successful_transaction'
    else
      redirect to '/failed_transaction'
    end
  end

  post '/withdraw' do
    if Float(params[:withdraw]) > 0 && current_user.balance - Float(params[:withdraw]) >= 0
      current_user.update(balance:current_user.withdraw(params[:withdraw]))
      redirect to '/successful_transaction'
    else
      redirect to '/failed_transaction'
    end
  end

  get '/successful_transaction' do
    erb :successful_transaction
  end

  get '/failed_transaction' do
    erb :failed_transaction
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
