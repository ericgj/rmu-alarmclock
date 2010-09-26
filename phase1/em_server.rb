require 'rubygems'
require "bundler"
Bundler.setup(:em)
require File.join(File.dirname(__FILE__),'lib', 'em_protocols', 'simple_json_client')
require File.join(File.dirname(__FILE__),'lib', 'em_protocols', 'simple_json_server')
require File.join(File.dirname(__FILE__),'lib', 'shared', 'reminder')
require File.join(File.dirname(__FILE__),'lib', 'shared', 'environment')
require File.join(File.dirname(__FILE__),'lib', 'server', 'alarm_client')
require File.join(File.dirname(__FILE__),'lib', 'server', 'reminder_server')

