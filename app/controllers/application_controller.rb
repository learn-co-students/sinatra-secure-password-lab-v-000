require "./config/environment"
require "./app/models/user"
require 'pry'
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
    @user = User.new(username: params[:username], password: params[:password])
    if @user.save
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
    @user = User.find_by(username: params[:username])
		if @user && @user.authenticate(params[:password])
			session[:user_id] = @user.id
			redirect to('/account')
		else
			redirect to('/failure')
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

  post "/deposit" do
    new_balance = current_user.balance + params[:deposit_amount].to_i
    current_user.update(balance: new_balance)
    redirect '/account'
  end

  post "/withdraw" do
    withdrawal = params[:withdraw_amount].to_i
    if current_user.balance > withdrawal
      new_balance = current_user.balance - withdrawal
      current_user.update(balance: new_balance)
      redirect '/account'
    else
      redirect '/failure'
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
