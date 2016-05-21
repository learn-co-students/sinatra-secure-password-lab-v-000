require "./config/environment"
require "sinatra/activerecord/rake"
require 'pry'

task :console do

  def reload!
    load_all 'app'
  end

  Pry.start
end
