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
    if user.save
      redirect to '/login'
    else
      redirect to '/failure'
    end
  end

  get '/account' do
    erb :account
  end

  get '/account/deposit' do
    erb :deposit
  end

  patch '/account/deposit' do
    new_balance = current_user.balance + params[:deposit_amount].to_f
    current_user.update(balance: new_balance)
    redirect '/account'
  end

  patch '/account/withdraw' do
    if params[:withdraw_amount].to_f < current_user.balance
      new_balance = current_user.balance - params[:withdraw_amount].to_f
      current_user.update(balance: new_balance)
      redirect '/account'
    else
      'Withdraw request exceeds your balance.'
    end
  end

  get '/account/withdraw' do
    erb :withdraw
  end

  get "/login" do
    erb :login
  end

  post "/login" do
    if params[:username].empty? || params[:password].empty?
      redirect to '/failure'
      else
      user = User.find_by(username: params[:username])
      if user && user.authenticate(params[:password])
        session[:user_id] = user.id
        redirect to '/account'
      else
        redirect to '/failure'
      end
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

    def current_balance
      if current_user.balance.nil?
        current_user.update(balance: 0.0)
        current_user.balance
      else
        current_user.balance
      end
    end
  end

end
