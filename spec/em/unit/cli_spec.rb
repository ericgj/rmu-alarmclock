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

