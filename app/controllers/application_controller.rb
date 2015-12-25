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
    if blank_form?
      redirect "/failure"
    else
      user = User.create(username: params[:username], password: params[:password], balance: 0)
      redirect "/login"
    end
  end

  get "/login" do
    erb :login
  end

  post "/login" do
    if blank_form?
      redirect "/failure"
    else
      user = User.find_by(username: params[:username])
      if user && user.authenticate(params[:password])
        session[:id] = user.id
        redirect "/success"
      end
    end
  end

  get "/success" do
    if logged_in?
      redirect "/account"
    else
      redirect "/failure"
    end
  end

  get "/account" do
    erb :account
  end

  post "/transaction" do
    if enough_funds?
      User.complete_transaction(session, params)
      redirect "/balance"
    else
      redirect "/failure"
    end
  end

  get "/balance" do
    erb :balance
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
      !!session[:id]
    end

    def current_user
      User.find(session[:id])
    end

    def blank_form?
      params.values.any?{|login_field| login_field.empty?}
    end

    def enough_funds?
      !params[:deposit].empty? || current_user.balance >= params[:withdrawal].to_i
    end
  end

end
