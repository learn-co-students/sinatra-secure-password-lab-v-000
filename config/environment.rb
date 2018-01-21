require 'bundler'
Bundler.require

configure :development do
	set :database, {adapter: "sqlite3", database: "db/database.sqlite"}
end
require_relative '../app/controllers/application_controller.rb'
require_all 'app/models'
