require File.join(File.dirname(__FILE__),'..','..','helper')
require File.join(File.dirname(__FILE__),'..','helper')

require 'lib/em/em_client'

# Note: No EM reactor needed

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

# Note: EM reactor stubbed

describe 'CLI::ReminderClient' do
    
  it 'it should call send_data with the initial data in post_init' do
    @subject = EmSpecHelper.stub_connection(
                CLI::ReminderClient, "data", 
                :stubs => Proc.new { |stub|
                             stub.expects(:send_data).with("data").once
                           }
               )
  end
  
  it 'it should call close_connection_after_writing in post_init' do
    @subject = EmSpecHelper.stub_connection(
                CLI::ReminderClient, "data", 
                :stubs => :close_connection_after_writing
               )
  end
  
  it 'should stop the EM reactor when unbinding' do
    @subject = EmSpecHelper.stub_connection(
                CLI::ReminderClient, "data"
               ) { |conn|  EM.expects(:stop); conn.unbind }
  end
  
end

# Note: actual EM reactor run, dummy server listening on socket (on separate thread)

describe 'CLI', 'run' do
    
  describe 'when server is listening' do
    before do
      @server_thread = EmSpecHelper.start_server_thread(
                         EmSpecHelper::DummyServer,
                         '127.0.0.1', 5544
                       )
    end
    
    after do
      EmSpecHelper.stop_server_thread(@server_thread)
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

