require 'spec_helper'

describe 'App' do
  describe "GET '/'" do
    it "returns a 200 status code" do
      get '/'
      expect(last_response.status).to eq(200)
    end
  end

  describe "Signing Up" do

    it "displays Sign Up Page" do
      get '/signup'
      expect(last_response).to include('Username:')
      expect(last_response).to include('Password:')
    end

    it "displays the failure page if no username is given" do
      post '/signup', {"username" => "", "password" => "hello"}
      expect(last_response).to include('Flatiron Bank Error')
    end

    it "displays the failure page if no password is given" do
      post '/signup', {"username" => "", "password" => "hello"}
      expect(last_response).to include('Flatiron Bank Error')
    end

    it "displays the log in page if username and password is given" do
      post '/signup', {"username" => "avi", "password" => "I<3Ruby"}
      expect(last_response).to include('Login')
    end

  end

  describe "Logging In" do
    it "displays Sign Up Page" do
      get '/login'
      expect(last_response).to include('Username:')
      expect(last_response).to include('Password:')
    end

    it "displays the failure page if no username is given" do
      post '/login', {"username" => "", "password" => "I<3Ruby"}
      follow_redirect!
      expect(last_response).to include('Flatiron Bank Error')
      expect(session[:id]).to be(nil)
    end

    it "displays the failure page if no password is given" do
      post '/login', {"username" => "avi", "password" => ""}
      follow_redirect!
      expect(last_response).to include('Flatiron Bank Error')
      expect(session[:id]).to be(nil)
    end

    it "displays the user's account page if username and password is given" do
      post '/login', {"username" => "avi", "password" => "I<3Ruby"}
      follow_redirect!
      expect(last_response).to include('Welcome')
      expect(last_response).to include('avi')
      expect(session[:id]).to not_be(nil)
    end
  end

  describe "GET '/logout'" do
    it "clears the session" do
      get '/logout'
      expect(session[:id]).to be(nil)
    end
  end

  describe "User Model" do
    it "responds to authenticate method from has_secure_password" do
      @user = User.new("username" => "test", "password" => "1234")
      @user.save
      expect(@user.authenticate("1234")).to be_truthy
    end
  end

end