require 'rubygems'
require "bundler"
Bundler.setup(:em)
require File.join(File.dirname(__FILE__),'lib','reminder')
require File.join(File.dirname(__FILE__),'lib','reminder_response')
require File.join(File.dirname(__FILE__),'lib', 'server', 'reminder_server')
require File.join(File.dirname(__FILE__),'lib', 'server', 'simple_alarm_client')
require File.join(File.dirname(__FILE__),'lib', 'server', 'app')