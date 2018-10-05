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

    if !params[:username].empty? && !params[:password].empty?
      user = User.new(username: params[:username], password: params[:password], balance: 0)
      user.save
      redirect to '/login'
    else
      redirect to '/failure'
    end

  end

  get '/account' do
    @user = User.find(session[:user_id])
    erb :account
  end

  patch '/account/:id' do
    @user = User.find(params[:id])

    if @user.balance < params[:withdrawl].to_i
      puts "Error. Please enter an amount that is less than current balance"
    elsif !params[:deposit].empty? || !params[:withdrawl].empty?
      new_balance = @user.balance + params[:deposit].to_i - params[:withdrawl].to_i
      @user.update(balance: new_balance)
    end

    erb :account
  end


  get "/login" do
    erb :login
  end

  post "/login" do
    binding.pry
    user = User.find_by(username: params[:username])

    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect to '/account'
    else
      redirect to '/failure'
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
