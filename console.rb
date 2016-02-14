require_relative './config/environment'
require 'pry'

def reload!
    load './app/models/user.rb'
    # load './app/controllers/ap'
end

require_relative "./app/models/user.rb"

Pry.start