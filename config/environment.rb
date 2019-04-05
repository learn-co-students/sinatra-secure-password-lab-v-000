ENV['SINATRA_ENV'] ||= "development"

require 'capybara/dsl'
require 'bundler/setup'
Bundler.require(:default, ENV['SINATRA_ENV'])

ActiveRecord::Base.establish_connection(
:adapter => "sqlite3",
:database => "db/#{ENV['SINATRA_ENV']}.sqlite"
)

require_all 'app'
#configure :development do
	#set :database, {adapter: "sqlite3", database: "db/database.sqlite3"}
#end
require_relative '../app/controllers/application_controller.rb'
require_all 'app/models'
