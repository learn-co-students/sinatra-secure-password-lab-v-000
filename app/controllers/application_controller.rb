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
     if params[:username]=="" || params[:password]==""
       redirect '/failure'
     end

    user = User.new(username: params[:username], password: params[:password])
    if user.save
      redirect '/login'
    else
      redirect '/failure'
    end
  end

  get '/account' do
    # @user = User.find(session[:user_id])
    @user = current_user
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
    ##your code here
    user = User.find_by(username: params[:username])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect '/account'
    else
      redirect '/failure'
    end
  end

  post '/transfer' do
    user = current_user

    if user && !logged_in?
      redirect '/failure'
    end

    if params[:transfer_type]=="Deposit"
      user.balance += params[:amount].to_i
      user.save
    elsif params[:transfer_type]=="Withdrawal"
      if params[:amount].to_i <= user.balance
        user.balance -= params[:amount].to_i
        user.save
      else
        redirect '/insufficient'
      end
    else
      redirect '/failure'
    end

    redirect '/account'

  end

  get '/insufficient' do
    erb :insufficient
  end

  # get "/success" do
  #   if logged_in?
  #     erb :success
  #   else
  #     redirect "/login"
  #   end
  # end

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
