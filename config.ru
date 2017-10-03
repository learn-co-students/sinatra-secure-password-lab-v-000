require './app/controllers/application_controller'

use Rack::MethodOverride #middleware that lets you send out patch requests
run ApplicationController
