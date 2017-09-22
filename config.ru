require './app/controllers/application_controller'

ActiveRecord::Base.logger = nil

run ApplicationController
