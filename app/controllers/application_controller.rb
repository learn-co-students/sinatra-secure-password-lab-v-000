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
    if params[:username] ==""
      redirect '/failure'
    else
      user = User.new(username: params[:username], password: params[:password], balance: 0)
      if user.save
        redirect '/login'
      else
        redirect '/failure'
      end
    end
  end

  get '/account' do
    if logged_in?
      @user = User.find(session[:user_id])
      User.update(@user.id, :balance => 0) if @user.balance==nil
      #update balance to 0 for users created prior to adding balance column
      erb :account
    else
      redirect "/login"
    end
  end

  get "/login" do
    erb :login
  end

  post "/login" do
    user = User.find_by(:username => params[:username])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect "/account"
    else
      redirect "/failure"
    end
  end

  post '/transaction' do
    @user = User.find(session[:user_id])
    deposit = params[:deposit].to_f
    withdrawl = params[:withdrawl].to_f
    ending_balance = valid_trans?(@user.balance, deposit, withdrawl)
    if ending_balance
      User.update(@user.id, :balance => ending_balance)
      "<p>deposit: #{deposit}</p> <p> withdrawl: #{withdrawl} </p> <p> transaction processed <a href='/account'>click here to return to account</a></p>"
    else
      "<p>transaction failed <a href='/account'>click here to return to account</a></p>"
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

    def valid_trans?(balance, deposit, withdrawl)
      ending_balance = balance + deposit- withdrawl
      ending_balance >=0 ? ending_balance : false
    end
  end

end
