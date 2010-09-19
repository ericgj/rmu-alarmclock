$LOAD_PATH << File.expand_path(File.dirname(__FILE__))

namespace :test do

  task :setup do
    require 'rubygems'
    require 'bundler'
    Bundler.setup(:test)
    require 'bacon'
    #Bacon.extend Bacon::TestUnitOutput
    Bacon.summary_on_exit
  end
  
  namespace :em do
  
    task :unit => ['test:setup'] do
      puts "-----------------------\nUnit tests\n-----------------------"
      Dir['spec/em/unit/**/*.rb'].each {|f| load f; puts "-----"}
    end
    
    task :functional => ['test:setup'] do
      puts "-----------------------\nFunctional tests\n-----------------------"
      Dir['spec/em/functional/**/*.rb'].each {|f| load f; puts "-----"}
    end
    
  end
  
end
