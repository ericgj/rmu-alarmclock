$LOAD_PATH << File.expand_path(File.join(File.dirname(__FILE__),".."))

require 'baconmocha'
Bacon.summary_on_exit

Bundler.setup(:em)
require 'eventmachine'
require 'json'
require 'json/add/core'

Dir[File.expand_path(File.join(File.dirname(__FILE__),'shared','**','*.rb'))].
  each {|f| require f}