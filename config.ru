require './app/controllers/application_controller'


run ApplicationController



# require_relative './config/environment'

# if ActiveRecord::Migrator.need_migration?
#     raise 'Migrations are pending. Run 'rake db:migrate' to resolve the issue.'
# end

# use Rack::MethodOverride
# run ApplicationController