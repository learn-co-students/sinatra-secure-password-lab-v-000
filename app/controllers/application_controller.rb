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
    if empty_input?(params)
      redirect to "/failure"
    else
      user = User.new(:username => params[:username], :password => params[:password])
      user.save
      redirect to "/login"
    end
  end

  get '/account' do
    erb :account
  end


  get "/login" do
    erb :login
  end

  post "/login" do
    user = User.find_by(username: params[:username])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect to "/account"
    else
      redirect to "/failure"
    end
  end

  get "/failure" do
    erb :failure
  end

  get "/logout" do
    session.clear
    redirect "/"
  end

  patch "/deposit" do
    session[:failed_withdrawal?] = false
    balance = current_user.balance + params[:deposit].to_f
    current_user.update(balance: balance)
    redirect "/account"
  end

  patch "/withdraw" do
    session[:failed_withdrawal?] = false
    balance = current_user.balance - params[:withdrawal].to_f
    if balance >= 0
      current_user.update(balance: balance)
    else
      session[:failed_withdrawal?] = true
    end
    redirect "/account"
  end

  helpers do
    def logged_in?
      !!session[:user_id]
    end

    def current_user
      User.find(session[:user_id])
    end

    def empty_input?(params)
      params.values.map(&:strip).include?("")
    end

    def withdrawal_error
      "Withdrawal amount can't be greater than balance."
    end
  end

end
