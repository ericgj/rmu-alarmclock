require File.join(File.dirname(__FILE__),'..','..','helper')
require 'baconmocha'

require 'lib/em/server/reminder_server'

# stub EM.add_timer
class EventMachine
  def self.add_timer(sec, &blk)
    sleep(sec); blk.call
  end
end

describe 'ReminderServer', 'valid command' do

  # something like
  stub_connection(ReminderServer) do |conn|
    conn.each_reminder do |r|
      # do something to verify
      true.should.eql true
    end
    conn.receive_data "{\"start_at\": #{Time.now + 1}}"
  end
  
end

describe 'ReminderServer', 'invalid command' do

end
