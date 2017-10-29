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
    user = User.new(username: params[:username], password: params[:password]) if filled_out(params)
    user ? (redirect '/account') : (redirect '/failure')
    binding.pry
    user.save
  end

  get '/account' do
    @user = current_user
    @balance = Money.new((@user.balance * 100).to_s).format
    erb :account
  end 

  get "/login" do
    erb :login
  end 

  post "/login" do
    redirect "/failure" if !filled_out(params)
    user = User.find_by(username: params[:username])
     if user && user.authenticate(params[:password])
        session[:user_id] = user.id
        redirect "/account"
     end 
  end 

  get "/success" do
    logged_in? ? (erb :success) : (redirect "/login")
  end

  get "/failure" do
    erb :failure
  end

  get "/logout" do
    session.clear
    redirect "/"
  end

  post "/deposit" do
    current_user.deposit(params[:deposit])
    redirect "/account"
  end

  post "/withdraw" do
    current_user.withdraw(params[:withdrawal])
    redirect "/account"
  end

  helpers do
    def logged_in?
      !!session[:user_id]
    end

    def current_user
      User.find(session[:user_id])
    end

    def filled_out(params)
      params.all? {|k,v| v != ""}
    end
  end

end
