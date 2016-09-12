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
    user = User.new(:username => params[:username], :password => params[:password], :balance => 0)
    if !params[:username].empty? && user.save
      redirect '/login'
    else
      redirect '/failure'
    end
  end

  get '/account' do
    @user = User.find(session[:user_id])
    erb :account
  end

  post '/account' do
    @user = User.find(session[:user_id])
    if !params[:deposit].empty? && params[:deposit].to_f != 0.0
      @user.update(:balance => @user.balance += params[:deposit].to_f)
    elsif !params[:withdraw].empty? && params[:withdraw].to_f != 0.0
      balance = @user.balance
      new_amount = balance - params[:withdraw].to_f
      if new_amount < 0
        @message = "that's too much money"
      else @user.update(:balance => @user.balance -= params[:withdraw].to_f)
        @message = "withdrew $#{params[:withdraw]}"
      end
    else
      redirect '/failure'
    end
    erb :account
  end


  get "/login" do
    erb :login
  end

  post "/login" do
    ##your code here
    user = User.find_by(:username => params[:username])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect '/account'
    else
      redirect '/failure'
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

  helpers do
    def logged_in?
      !!session[:user_id]
    end

    def current_user
      User.find(session[:user_id])
    end
  end

end
