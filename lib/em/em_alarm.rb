require 'rubygems'
require "bundler"
Bundler.setup(:em)
require File.join(File.dirname(__FILE__),'lib', 'shared', 'reminder')
require File.join(File.dirname(__FILE__),'lib', 'shared', 'reminder_response')
require File.join(File.dirname(__FILE__),'lib', 'shared', 'environment')
require File.join(File.dirname(__FILE__),'lib', 'alarm', 'simple_alarm_server')
