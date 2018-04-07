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
    # raise params.inspect
    if params[:username] == "" || params[:password] == ""
      redirect '/failure'
    else
      @user = User.create(username: params[:username], password: params[:password], balance: params[:balance])
      redirect '/login'
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
    ##your code here
    @user = User.find_by(username: params[:username])
    if @user && @user.authenticate(params[:password])
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

  post '/deposit' do
    @message = "Success!"
    @amount = params[:amount]
    @transaction = params[:transaction]
    User.make_deposit(current_user, params[:amount].to_f)
    erb :account
  end

  post '/withdrawal' do
    if current_user.balance < params[:amount].to_f
      @message = "Error! Please check Account Balance"
      erb :account
    else
      User.make_withdrawal(current_user, params[:amount].to_f)
      @message = "Success!"
      @amount = params[:amount]
      @transaction = params[:transaction]
      erb :account
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
