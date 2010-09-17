require File.join(File.dirname(__FILE__),'..','..','helper')
require File.join(File.dirname(__FILE__),'..','helper')

require 'lib/em/lib/reminder'
require 'lib/em/lib/server/reminder_server'


describe 'ReminderServer', 'receives valid command' do

  it 'should throw reminder near the specified time' do
    
    @host = 'localhost'; @port = 5544
    @start_time = Time.now
    @reminder = Reminder.new({"start_at" => @start_time + 3})
    
    @th = Thread.current
    EM.run {
      server = ReminderServer.start(@host, @port)
      
      server.each_reminder do |r|
        @th.wakeup
        r.should.eql @reminder
        @start_time.should.
          satisfy('near') { |t| (Time.now - t).between?(3.1, 3.2) }
      end
    
      server.unparseable_command do |cmd|
        @th.wakeup
        puts "unparseable: #{cmd}"
      end
      
      server.invalid_message do |msg|
        @th.wakeup
        puts "invalid: #{msg}"
      end
      
      # sends data on a different thread and disconnects, 
      # mimicking an EM reactor running in a separate process
      EmSpecHelper.start_connect_thread(
                             EmSpecHelper::DummyClient,
                             @host, @port,
                             @reminder.to_json + "\n\r"
                            )
      
    }
    
    #EmSpecHelper.stop_connect_thread(@th)
    
  end
  
end