require "./config/environment"
require "sinatra/activerecord/rake"

task :drop_and_migrate do
  puts "dropping database..."
  system("rm db/development.sqlite && rm db/schema.rb && rm db/test.sqlite")
  puts "migrating database..."
  system("bundle exec rake db:migrate && bundle exec rake db:migrate SINATRA_ENV=test")
  puts "seeding data"
  system("bundle exec rake db:seed")
end
