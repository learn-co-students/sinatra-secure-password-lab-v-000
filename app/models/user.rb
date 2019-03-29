class User < ActiveRecord::Base
  has_secure_password
end


# def initialize
#   @params = params
#   @username = params[:username]
#   @password = params[:password]
# end
