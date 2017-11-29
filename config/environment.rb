require 'bundler'
Bundler.require(:default, :development)

configure :development do
	set :database, {adapter: "sqlite3", database: "db/database.sqlite3"}
end
require_relative '../app/controllers/application_controller.rb'
require_all 'app/models'
