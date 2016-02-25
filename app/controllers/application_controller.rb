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
    #your code here!
    user = User.new(username: params[:username], password: params[:password], balance: 0)
    if user.save && !user.username.empty?
      redirect to "/login"
    else
      redirect to "/failure"
    end
  end


  get "/login" do
    erb :login
  end

  post "/login" do
    #your code here!
    user = User.find_by(username: params[:username])
    if user && user.authenticate(params[:password])
      session[:id] = user.id
      redirect to "/account"
    else
      redirect to "/failure"
    end
  end

=begin replaced with /account
  get "/success" do
    if logged_in?
      erb :account
    else
      redirect "/login"
    end
  end
=end

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

  # deposits or withdraws from balance
  post "/action" do
    user = User.find(session[:id])
    if params[:transaction] == "deposit"
      user.balance += params[:amount].to_f
    elsif user.balance > params[:amount].to_f && params[:transaction] == "withdraw"
      user.balance -= params[:amount].to_f
    else
      redirect to '/failure'
    end
    user.save
    redirect to '/account'
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
