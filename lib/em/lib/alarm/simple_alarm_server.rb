
module Remindr
module SimpleAlarmServer
  include ::EM::Protocols::JSON::Simple

  def self.start(host, port, &blk)
    EM.start_server(host, port, self, &blk)
  end

  def receive_message msg
    puts "#{Time.now}\n#{msg.message}"
    play_sound
  end

  def parse line
    Reminder.new(JSON.parse(line))
  end
    
  protected
  
  def play_sound
    `esdcat "#{APPENV.alarm.sound}"` unless APPENV.alarm.sound.empty?
  end
  
end
end