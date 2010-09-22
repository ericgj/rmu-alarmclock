require 'rubygems'
require "bundler"
Bundler.setup(:em)
require File.join(File.dirname(__FILE__),'lib', 'shared', 'reminder')
require File.join(File.dirname(__FILE__),'lib', 'shared', 'json_client')
require File.join(File.dirname(__FILE__),'lib', 'shared', 'environment')
require File.join(File.dirname(__FILE__),'lib', 'client', 'cli')
