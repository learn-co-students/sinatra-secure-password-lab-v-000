class User
attr_reader: username, :password

  def initialize(params)
    @params = params
    @username = params[:username]
    @password = params[:password]
  end

end
