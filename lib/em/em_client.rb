require 'rubygems'
require "bundler"
Bundler.setup(:default)
require File.join(File.dirname(__FILE__),'lib','reminder')
require File.join(File.dirname(__FILE__),'lib', 'client', 'cli')