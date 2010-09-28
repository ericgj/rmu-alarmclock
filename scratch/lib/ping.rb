# This is a sample
# to mimic Growl (GNTP) client-server interactions.
#
# Ping plays the part of the GNTP client.
# It connects to the server and sends messages while listening
#   for responses.
# It keeps the socket open until it receives two responses.
# This mimics the GNTP case where a notification request is sent
#   expecting a callback: The GNTP server first sends back a 
#   response synchronously, and then later asynchronously when
#   a callback event is fired.
#
# Pong plays the part of the GNTP server. 
# It listens for connections, and responds to the peer both 
#       synchronously  (send_data within receive_data)
#   and asynchronously  (send_data within EM.add_timer).
# It does not hang up either the incoming or outgoing connection.
# 

require 'rubygems'
require 'eventmachine'

class Ping < EM::Connection
  
  def self.trigger(msg, opts = {})
    connection = EM.connect opts[:host], opts[:port], self, msg, opts
    connection
  end
  
  def initialize(msg = nil, opts = {})
    super
    @msg = msg
    @opts = opts
  end
  
  def post_init
    @count = 0
    @buffer = BufferedTokenizer.new("\r")
    if @msg
      puts "Ping said #{@msg}..."
      send_data @msg + "\n\r"
    end
  end
  
  def connection_completed
  end
  
  def receive_data data
    @buffer.extract(data).each do |line|
      @count += 1
      puts "    Ping heard back '#{line.chomp!}' (#{@count})"
    end
    close_connection_after_writing if @count >= 2
  end
  
end


EM.run {

  EM.add_periodic_timer(5) {
  
    host = 'localhost'
    port = 5578
    msg = ['it', 'rider', 'iris', 'thimble', 'yeti', 'cookie', 'flipper', 'i']
    
    Ping.trigger(msg[rand(msg.size)], :host => host, :port => port)
    
  }
}