require 'rubygems'
require "bundler"
Bundler.setup(:em)
require File.join(File.dirname(__FILE__),'lib', 'shared', 'reminder')
require File.join(File.dirname(__FILE__),'lib', 'shared', 'reminder_response')
require File.join(File.dirname(__FILE__),'lib', 'shared', 'environment')
require File.join(File.dirname(__FILE__),'lib', 'server', 'reminder_server')
require File.join(File.dirname(__FILE__),'lib', 'server', 'simple_alarm_client')

#### probably the app should be run within a daemon
#### in bin/remindrd
# require File.join(File.dirname(__FILE__),'lib', 'server', 'app')