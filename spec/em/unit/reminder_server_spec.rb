require File.join(File.dirname(__FILE__),'..','..','helper')
require File.join(File.dirname(__FILE__),'..','helper')

require 'lib/em/lib/reminder'
require 'lib/em/lib/server/reminder_server'

# stub EM.add_timer
module EventMachine
  def self.add_timer(sec, &blk)
    sleep(sec); blk.call
  end
end

describe 'ReminderServer', 'valid command' do

  it 'should throw each_reminder with reminder matching received message' do

    @reminder = Reminder.new({'start_at' => Time.now + 1})
    EmSpecHelper.stub_connection(ReminderServer) do |conn|
      conn.each_reminder do |r|
        r.should.not.be.nil
        r.each_pair {|k, v| v.should.eql @reminder[k]}
      end
      conn.unparseable_command do |cmd|
        should.flunk "Command unparseable: #{cmd}"
      end
      conn.invalid_message do |msg|
        should.flunk "Invalid message: #{msg}"
      end
      conn.receive_data(@reminder.to_json + "\n\r")
    end
  
  end
   
end

describe 'ReminderServer', 'invalid message format' do

  it('should throw invalid_message with message') { should.flunk 'Not yet implemented' }
  
end

describe 'ReminderServer', 'unparseable command' do

  it('should throw unparseable_command with message') { should.flunk 'Not yet implemented' }
  
end
