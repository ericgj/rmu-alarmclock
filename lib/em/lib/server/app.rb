# TODO config APPENV with external file
APPENV = { 'host' => 'localhost',
           'port' => 5544,
           'alarm-host' => 'localhost',
           'alarm-port' => 5545
         }
         

EM.run {

  ReminderServer.start(APPENV['host'], APPENV['port']) do |server|
    
    server.each_reminder do |reminder|
    
      alarm = SimpleAlarmClient.connect(
                APPENV['alarm-host'], APPENV['alarm-port'], 
                reminder
              )

      alarm.snooze do |response|
        # TODO handle snooze response
        # by sending new reminder that sets a periodic timer unless
        # already set
      end
      
      alarm.off do |response|
        # TODO handle off response
        # by setting off periodic timer identified by timer_id
      end
            
    end
    
    # TODO these error conditions
    # should be sent back to the client somehow?
    server.unparseable_command do |cmd|
      $stdout.print "Unparseable command received: `#{cmd}`\n"
      $stdout.flush
    end
        
    server.invalid_message do |msg|
      $stdout.print "Invalid message received: `#{msg}`\n"
      $stdout.flush
    end
    
  end
  
}

