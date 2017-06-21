task :default => :console

desc "Loads modules in ./config/environment.rb"
task :environment do
  require_relative "./config/environment.rb"
end

task :run do
  require_relative "./bin/run.rb"
end

desc "Opens a pry console after loading run.rb. This is the default task."
task :console => :run do
  pry.Start
end
