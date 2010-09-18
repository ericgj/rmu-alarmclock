require File.join(File.dirname(__FILE__),'..','..','helper')
require File.join(File.dirname(__FILE__),'..','helper')

require 'lib/em/lib/reminder'
require 'lib/em/lib/server/reminder_server'


describe 'ReminderServer', 'receives valid command' do

  it 'should throw reminder near the specified time (3 sec)' do
    
    @host = 'localhost'; @port = 5544
    @start_time = Time.now
    @reminder = Reminder.new({"start_at" => @start_time + 3})
    
    @th = Thread.current
    EM.run {
    
      ReminderServer.start(@host, @port) do |server|
        
        server.each_reminder do |r|
          @th.wakeup
          now = Time.now
          r.should.eql @reminder
          $stdout.print "\n    Note: reminder received in #{now - @start_time} seconds.\n"
          $stdout.flush
          now.should.
            satisfy("Not near specified time (delta=#{now - @reminder.start_at}") do |t| 
              (t - @reminder.start_at).between?(-0.1, 0.1)
            end
          EM.next_tick { EM.stop }
        end
      
        server.unparseable_command do |cmd|
          @th.wakeup
          should.flunk "Received unparseable: #{cmd}"
          EM.next_tick { EM.stop }
        end
        
        server.invalid_message do |msg|
          @th.wakeup
          should.flunk "Received invalid: #{msg}"
          EM.next_tick { EM.stop }
        end
     
     end
     
      # sends data on a different thread and disconnects, 
      # mimicking an EM reactor running in a separate process
      EmSpecHelper.start_connect_thread(
                             EmSpecHelper::DummyClient,
                             @host, @port,
                             @reminder.to_json + "\n\r"
                            )
      
    }
    
    #### Note this not needed -- thread is killed when EM.stop
    # EmSpecHelper.stop_connect_thread(@th)
    
  end
  
end