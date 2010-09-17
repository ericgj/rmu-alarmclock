require 'rubygems'
require "bundler"
Bundler.setup(:default)
require File.join(File.dirname(__FILE__),'lib','reminder')
require File.join(File.dirname(__FILE__),'lib', 'server', 'reminder_server')
require File.join(File.dirname(__FILE__),'lib', 'server', 'app')