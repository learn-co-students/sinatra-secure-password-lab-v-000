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
    # binding.pry
    @user = User.new(:username => params[:username], :password => params[:password], :balance => 0, :acct_num => rand(10**10))
    
    if @user.username == "" || @user.password == ""
      redirect "/failure"
    elsif @user.save
      redirect "/login"
    else 
      redirect "/failure"
    end
  end

  get '/account' do
    if logged_in?
      erb :account
    else 
      redirect '/failure'
    end
  end


  get "/login" do
    erb :login
  end

  post "/login" do
    session.clear
    @user = User.find_by(:username => params[:username])
    
    if params[:username] == "" || params[:password] == ""
      redirect '/failure'
    elsif @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
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
    redirect "/"
  end

  get "/badwithdraw" do
    erb :badwithdraw
  end

  post "/deposit" do
    binding.pry
    current_user.update(balance: (current_user.balance + params[:deposit].to_i))
    
    redirect '/account'
  end

  post "/withdraw" do
    binding.pry
    if current_user.balance - params[:withdraw].to_i >= 0
      current_user.update(balance: (current_user.balance - params[:withdraw].to_i))
      redirect '/account'
    else 
      redirect '/badwithdraw'
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
