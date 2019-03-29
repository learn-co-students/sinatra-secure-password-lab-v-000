class User < ActiveRecord::Base
  has_secure_password
end


def initialize(params)
  @username = params[:username]
  @password = params[:password]
end
