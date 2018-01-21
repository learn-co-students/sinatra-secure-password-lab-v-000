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
    if params[:username].empty? || params[:password].empty?
      redirect '/failure'
    end
    user = User.new(username: params[:username], password: params[:password])
    if user.save
      session[:user_id] = user.id
      redirect '/login'
    else
      redirect '/failure'
    end
  end

  get '/account' do
    @user = current_user
    erb :account
  end

  get '/withdraw_error' do 
    @amount
    @user = current_user
    erb :error
  end

  post '/balance_update' do
    @user = current_user
    balance_change(params)
    @user.save
    redirect '/account'
  end

  get "/login" do
    erb :login
  end

  post "/login" do
    user = User.find_by(username: params[:username])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect '/success'
    else
      redirect '/failure'
    end
  end

  get "/success" do
    if logged_in?
      redirect '/account'
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

    def balance_change(params)
      @amount = params[:amount].to_f
      if params[:withdraw]
        if @amount > @user.balance
          redirect '/withdraw_error'
        else
          @user.balance -=  @amount
        end
      elsif params[:deposit]
        @user.balance +=  @amount
      else
        redirect '/account'
      end
    end
  end

end
