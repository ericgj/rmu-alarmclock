require 'rubygems'
require 'bundler'
Bundler.setup(:thin)
require File.join(File.dirname(__FILE__),"remindrd","app")