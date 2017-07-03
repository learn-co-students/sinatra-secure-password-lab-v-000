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
    user = User.new(username:params[:username], password:params[:password])
    if !user.username.empty? && user.save
      redirect to '/login'
    else
      redirect to '/failure'
    end

  end

  get '/account' do
    @user = User.find(session[:user_id])
    # raise @user.username.inspect

    erb :account
  end


  get "/login" do
    erb :login
  end

  post "/login" do
    ##your code here
    user = User.find_by(username:params[:username])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect '/account'
    else
      redirect '/failure'
    end
  end

  patch '/deposit' do
    user = User.find(current_user.id)
    user.balance += params[:deposit].to_d
    user.save
    redirect '/account'
  end

  patch '/withdraw' do
    user = User.find(current_user.id)
    if params[:withdraw].to_d <= user.balance
      user.balance -= params[:withdraw].to_d
      user.save
      redirect '/account'
    else
      # redirect to error page for now!!
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
