# TODO config APPENV with external file
APPENV = { 'host' => 'localhost',
           'port' => 5544,
           'alarm-host' => 'localhost',
           'alarm-port' => 5545
         }
         
module SimpleAlarmClient
  
  def initialize(reminder)
    @reminder = reminder
  end
  
  def post_init
    send_data @reminder.to_json
  end
  
end

EM.run {

  server = EM.start_server(APPENV['host'], APPENV['port'], ReminderServer)
  
  server.unparseable_command do |cmd|
    $stdout.print "Unparseable command received: `#{cmd}`\n"
    $stdout.flush
  end
  
  server.each_reminder do |reminder|
    EM.connect(APPENV['alarm-host'], APPENV['alarm-port'], SimpleAlarmClient, reminder)
  end
  
}

