require "./config/environment"
require "./app/models/user"
require 'pry'
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

    user = User.new(:username => params[:username], :password => params[:password], :balance => 0)
    if user.username != "" && user.password != ""
		user.save
			redirect "/account"
		else
			redirect "/failure"
		end
end
  get '/account' do
    @user = current_user
    erb :account
  end


  get "/login" do
    erb :login
  end

  post "/login" do
    user = User.find_by(:username => params[:username])
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

  # post '/account' do
  #   puts params
  # @user = current_user
  #   if @user.balance == nil
  #     @user.balance = 0
  #   end
  #   if params[:deposit].to_i >= 0
  #   @deposit = @user.balance + params[:deposit].to_i
  #   elsif params[:withdraw].to_i != 0
  #   @withdraw = @user.balance - params[:withdraw].to_i
  #   end
  #   @user
  #   erb :account
  # end


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
