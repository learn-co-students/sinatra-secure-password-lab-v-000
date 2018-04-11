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

    user = User.new(:username => params[:username], :password => params[:password])

    if user.username == ""
      redirect "/failure"
    elsif user.save
      redirect "/login"
    else
      redirect "/failure"
    end
  end


  get '/account' do

    if logged_in?
      @user = current_user

      erb :account
    else
      redirect "/failure"
    end
  end


  get "/login" do
    erb :login
  end

  post "/login" do
    #your code here
    user = User.find_by(:username => params[:username])

     if user && user.authenticate(params[:password])
       session[:user_id] = user.id
       redirect "/account"
     else
       redirect "/failure"
     end
   end

  get "/failure" do
    erb :failure
  end

  get "/logout" do
    session.clear
    redirect "/"
  end

  get '/deposit' do
    erb :deposit
  end

  post '/deposit' do
    if logged_in?
      current_user.update(balance: current_user.balance + params[:amount].to_f)

      redirect "/account"
    else
      redirect "/failure"
    end
  end

  get "/withdrawal" do
    erb :withdrawal
  end

  post '/withdrawal' do
    if logged_in? && current_user.balance >= params[:amount].to_f
      current_user.update(balance: current_user.balance - params[:amount].to_f)

      redirect "/account"
    else
      redirect "/failure"
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
