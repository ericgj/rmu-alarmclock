require File.join(File.dirname(__FILE__),'..','helper')

require 'em_client'

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

describe Remindr::CLI::ReminderClient do
    
  before do
    @reminder = Reminder.new
  end
  
  it 'it should call send_data with the initial data in post_init' do
    @subject = EmSpecHelper.stub_connection(
                Remindr::CLI::ReminderClient, @reminder, 
                :stubs => Proc.new { |stub|
                             stub.expects(:send_data).with(@reminder.to_json + "\n\r").once
                           }
               )
  end
  
  it 'it should call close_connection_after_writing in post_init' do
    @subject = EmSpecHelper.stub_connection(
                Remindr::CLI::ReminderClient, @reminder, 
                :stubs => :close_connection_after_writing
               )
  end
  
  it 'should stop the EM reactor when unbinding' do
    @subject = EmSpecHelper.stub_connection(
                Remindr::CLI::ReminderClient, @reminder
               ) { |conn|  EM.expects(:stop); conn.unbind }
  end
  
end

