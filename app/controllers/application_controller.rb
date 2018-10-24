require "./config/environment"
require "./app/models/user"
class ApplicationController < Sinatra::Base

  configure do
    set :views, "app/views"
    enable :sessions
    set :session_secret, ENV.fetch("SESSION_SECRET")
  end

  get "/" do
    erb :index
  end

  get "/signup" do
    erb :signup
  end

  post "/signup" do
    user = User.new(username: params[:username], password: params[:password])

    if params[:username] == ""
      redirect "/failure"
    elsif user.save
      redirect "/login"
    else
      redirect "/failure"
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
      redirect "/account"
    else
      redirect "/failure"
    end
  end

  get "/deposit" do
    erb :deposit
  end

  post "/deposit" do
    user = User.find(session[:user_id])
    user.update(balance: user.balance + params[:deposit_amount].to_f)
    redirect "/account"
  end

  get "/withdraw" do
    erb :withdraw
  end

  post "/withdraw" do
    user = User.find(session[:user_id])
    if params[:amount].to_f < user.balance
      user.update(balance: user.balance - params[:amount].to_f)
      redirect "/account"
    else
      @amount = params[:amount]
      erb :insufficient_funds
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
