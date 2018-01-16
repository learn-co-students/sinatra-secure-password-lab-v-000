require "./config/environment"
require "sinatra/activerecord/rake"


task :console do
  require 'pry'

  def reload!
    # Change 'gem_name' here too:
    files = $LOADED_FEATURES.select { |feat| feat =~ /\/gem_name\// }
    files.each { |file| load file }
  end

  ARGV.clear
  Pry.start
end
