$LOAD_PATH << File.expand_path(File.join(File.dirname(__FILE__),".."))

require 'rubygems'
require 'bundler'
Bundler.setup(:test)

require 'bacon'
require 'baconmocha'
Bacon.summary_on_exit
