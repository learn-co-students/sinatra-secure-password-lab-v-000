# require "./config/environment"
# require "./app/models/user"
class ApplicationController < Sinatra::Base

  configure do
    set :views, "app/views"
    enable :sessions
    set :session_secret, "password_security"
  end


  helpers do
    
    def logged_in?
      # !!session[:user_id]
      !!current_user
    end

    def login(user_id)
      session[:user_id] = user_id
    end

    def current_user
      @current_user ||= User.find_by(session[:user_id]) if session[:user_id]
    end

    def logout!
      session.clear
    end
  end

end
