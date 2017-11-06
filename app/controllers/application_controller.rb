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
    if user.save && user.username != ""
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

  post "/updated" do
    @user = current_user
    if params.keys.include?("withdraw") && @user
      req_withdraw = params[:withdraw].to_i
      if @user.balance >= req_withdraw
        new_balance = @user.balance - req_withdraw
        @user.update(balance: new_balance)
        erb :updated
      else
        redirect '/failure'
      end
    elsif params.keys.include?("deposit") && @user
      new_balance = @user.balance + params[:deposit].to_i
      @user.update(balance: new_balance)
      erb :updated
    else
      redirect '/failure'
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
