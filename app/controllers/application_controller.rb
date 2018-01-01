require "./config/environment"
require "./app/models/user"
require "pry" #added to allow pry to be used in this document
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
#binding.pry
        if params[:username] == "" || params[:password] == ""
          redirect "/failure"
        else
        #  binding.pry
          user = User.create(username: params[:username], password: params[:password])
          #note, User.create persists to the database, while User.new would only create an instance of the variable, and would you would later have to Call user.save to persist to database
          #you can chech the current database with User.all
          redirect "/login"
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
#binding.pry
    @user = User.find_by(:username => params[:username])  #this will check to see if the username exists in the database.  If it does it will pass the user's info to an instance variable that will be accessible in the view designated below
    #  We also need to check if that user's password matches up with the value in password_digest. We can use a method called authenticate. The method is provided for us by the bcrypt gem. Our authenticate method takes a string as an argument. If the string matches up against the password digest, it will return the user object, otherwise it will return false. Therefore, we can check that we have a user AND that the user is authenticated. If so, we'll set the session[:user_id] and redirect to the /success route. Otherwise, we'll redirect to the /failure route so our user can try again.

    if @user && @user.authenticate(params[:password])
        session[:user_id] = @user.id
        redirect "/account"
    else
        redirect "/failure"
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

#helper methods that are able to add logic to our view files and make them dynamic.  These are accessable in our view.erb files thanks to sinatra
  helpers do
    #is the user logged in, returns true or false if a user id exists in the current session
    def logged_in?
      !!session[:user_id]
    end
    #return the session's user id through the class method User.find(session[:user_id])
    def current_user
      User.find(session[:user_id])
    end
  end
end

# =>    TO DO
# =>    Get the tests to pass. You'll need to use 'bcrypt' to salt your password and make sure that it is encrypted.
# =>    You'll also need to create a users table. A user should have a username and password.
# =>    BONUS
# =>    Add a migration that gives the user model a balance (should start for any user at $0), and add functionality on the account page to make deposits and withdrawals. A user should never be able to withdraw more money than they have in their account.
