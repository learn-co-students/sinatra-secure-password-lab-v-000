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
    if params[:username] == "" ||  params[:password] == ""
      redirect '/failure'
    else
      @user = User.create(username: params[:username], password: params[:password])
      redirect '/login'
      # redirect '/login'
    end
  end


  get '/account' do
    @user = User.find(session[:user_id])
    erb :account
  end

  post '/users/:id/deposit' do
    @user = User.find(session[:user_id])
    @deposit = params[:deposit].to_i
    @user.deposit(@deposit)
    # raise params[:deposit].inspect
    # raise @user.valid?.inspect
    # @user.balance = @user.balance + @deposit
    #
    # @user.save
    # "Your transaction is successful"
    # "Your current balance is #{@user.balance}"
  end

  post '/users/:id/withdrawal' do
    @user = User.find(session[:user_id])
    @withdrawal = params[:withdrawal].to_i
    @user.withdrawal(@withdrawal)
    # if @user.balance >= @withdrawal
    #   @user.balance = @user.balance - @withdrawal
    #   @user.save
    #   "Your transaction is successful"
    #   "Your current balance is #{@user.balance}"
    # else
    #   "This transaction can't be completed."
    # end
  end


  get "/login" do
    erb :login
  end

  post "/login" do
    @user = User.find_by(username: params[:username])
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect to "/account"
    else
      redirect to "/failure"
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
