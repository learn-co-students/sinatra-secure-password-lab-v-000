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
    user = User.new(username: params[:username], password: params[:password])
    if user.save
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
    user = User.find_by(username: params[:username])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect '/account'
    else
      redirect '/failure'
    end
  end

  get "/failure" do
    erb :failure
  end

  get "/logout" do
    session.clear
    redirect '/'
  end

  patch "/account" do



    current_user = User.find(session[:user_id])
    # current_user.balance = current_user.balance + deposit(params[:deposit])
    current_user.update(params[:balance])
    redirect '/account'

    # redirect "/articles/#{article.id}"
    # user = User.find(params[:id])
    # puts user.name
      # balance = deposit(params[:deposit].to_d)
      # puts balance
    #   # redirect '/account'
  end

  # post "/deposit" do
  #   current_user.balance = deposit(params[:deposit].to_d)
  #   puts current_user.balance
  #   # redirect '/account'
  #  end
  #
  # post "/withdrawal" do
  #   withdrawal(params[:withdrawal].to_d)
  #   # redirect '/account'
  # end

  helpers do
    def logged_in?
      !!session[:user_id]
    end

    def current_user
      User.find(session[:user_id])
    end

    def deposit(amount)
      balance = current_user.balance + amount
      sprintf("%.2f", balance)
    end

    def withdrawal(amount)
      if current_user.balance >= amount
        current_user.balance = current_user.balance - amount
      else
        current_user.balance = current_user.balance
      end
      sprintf("%.2f", balance)
    end

    # def current_balance
    #   # balance = current_user.balance + deposit - withdrawal
    #   # sprintf("%.2f", balance)
    #
    #
    # end
  end

end
