require 'bundler'
Bundler.require


configure :development do
	set :database, {adapter: "sqlite3", database: "db/database.sqlite3"}
end
require_relative '../app/controllers/application_controller.rb'
require_all 'app/models'



# require 'bundler'
# Bundler.require

# ActiveRecord::Base.establish_connection(
# 	:adapter => "sqlite3", 
# 	:database => "db/database.sqlite3"
# )

# require_all 'app'