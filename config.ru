require_relative './config/environment'
require 'sinatra/activerecord/rake'

require './app/controllers/application_controller'

run ApplicationController
