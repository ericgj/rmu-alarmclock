require 'rubygems'
require "bundler"
Bundler.setup(:em)
require File.join(File.dirname(__FILE__),'lib','reminder')
require File.join(File.dirname(__FILE__),'lib','reminder_response')
require File.join(File.dirname(__FILE__),'lib', 'client', 'simple_alarm_server')
require File.join(File.dirname(__FILE__),'lib', 'client', 'cli')
require File.join(File.dirname(__FILE__),'lib', 'client', 'environment')
