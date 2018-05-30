require 'bundler'
Bundler.require

configure :development do
	set :database, {adapter: "sqlite3", database: "db/database.sqlite3"}
end

#ActiveRecord::Base.establish_connection(
#  :adapter => "sqlite3",
#  :database => "db/#{ENV['SINATRA_ENV']}.sqlite"
#)

require_relative '../app/controllers/application_controller.rb'
require_all 'app/models'