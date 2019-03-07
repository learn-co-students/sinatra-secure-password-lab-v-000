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
    user = User.new(username: params[:username], password: params[:password])
    user.save ? redirect("/login") : redirect("/failure")
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
    user = User.find_by(username: params[:username])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect "/account"

    else
      redirect "/failure"
    end
  end

  get "/failure" do
    erb :failure
  end

  get "/logout" do
    session.clear
    redirect "/"
  end

  post "/withdrawl" do
    begin
      withdrawn = current_user.withdrawl(params[:amount])
      withdrawn ? "successful withdrawl" : "Insufficent Funds"
    rescue => exception
      "enter only numbers"
    end
  end

  post "/deposit" do
    begin
      deposit = current_user.deposit(params[:amount])
      deposit ? "successful deposit" : "Error occured"
    rescue => exception
      "enter only numbers"
    end
  end

  get "/ajaxrequest/balance" do
    if logged_in?
      "#{current_user.balance}"
    else
      "ERROR: Not logged in."
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
