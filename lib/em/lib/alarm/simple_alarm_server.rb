
module SimpleAlarmServer
  include EM::Protocols::JSON::Simple

  def self.start(host, port, &blk)
    EM.start_server(host, port, self, &blk)
  end

  def receive_message msg
    play_sound
  end
  
  protected
  
  def play_sound
    `esdcat "#{APPENV.alarm_file}"`
  end
  
end
