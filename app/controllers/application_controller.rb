require "./config/environment"
require "./app/models/user"
class ApplicationController < Sinatra::Base

  configure do
    set :views, "app/views"
    set :public_folder, 'public'
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
    if user.save && !user.username.blank?
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
    user = User.find_by(:username => params[:username])
    redirect '/failure' if user.nil?
    if user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect '/success'
    else
      redirect "/failure"
    end

    ##your code here
  end

  get "/success" do
    if logged_in?
      redirect '/account'
    else
      redirect "/failure"
    end
  end

  post '/account' do
    if params[:withdraw]
      redirect '/failure' if params[:withdraw].to_f > current_user.balance
      User.update(current_user.id, :balance => (current_user.balance - params[:withdraw].to_f)) 
      
    else
       User.update(current_user.id, :balance => (current_user.balance + params[:deposit].to_f))
    end
    @user = current_user
    erb :account
  end

  get "/failure" do
    erb :failure
  end

  get '/withdraw' do
    redirect '/failure' unless logged_in?
    @user = current_user
    erb :withdraw
  end

  get '/deposit' do
    @user = current_user
    erb :deposit
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
