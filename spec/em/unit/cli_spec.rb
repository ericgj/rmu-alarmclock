require File.join(File.dirname(__FILE__),'..','..','helper')
#require 'baconmocha'
require 'eventmachine'

require 'lib/em/em_client'

module CLISpecHelper

  def self.start_server_thread(klass)
    Thread.new {
      EM.run {
          EM.start_server('127.0.0.1', 5544, klass)
        }
    }
  end
  
  def self.stop_server_thread(th)
    th.wakeup
    EM.stop
  end
  
end

module DummyServer
  
  def initialize
    $stdout.print "Connection initializing\n"; $stdout.flush
  end
  
  def post_init
    $stdout.print "Connection initialized\n"; $stdout.flush
  end
  
  def receive_data data
    $stdout.print "Data received\n"; $stdout.flush
    close_connection
  end
  
end

describe 'CLI', 'parse' do

  describe 'when no arguments' do
  
  end
  
  describe 'when 1 argument' do
  
  end
  
  describe 'when 2 arguments' do
  
  end
  
  describe 'when 3 arguments' do
  
  end
  
end

describe 'CLI', 'run' do
  
  describe 'when server is listening' do
    before do
      @server_thread = CLISpecHelper.start_server_thread(DummyServer)
    end
    
    after do
      CLISpecHelper.stop_server_thread(@server_thread)
    end
    
    it 'should run without errors' do
      @client_thread = Thread.current
      EM.run {
        EM.next_tick { CLI.run }
        @client_thread.wakeup
        true.should.eql true
      }
    end
  end
    
end

