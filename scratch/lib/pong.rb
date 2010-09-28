# This is a sample
# to mimic Growl (GNTP) client-server interactions.
#
# Pong plays the part of the GNTP server. 
# It listens for connections, and responds to the peer both 
#       synchronously  (send_data within receive_data)
#   and asynchronously  (send_data within EM.add_timer).
# It does not hang up either the incoming or outgoing connection.
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
require 'rubygems'
require 'eventmachine'
require 'socket'

class Pong  < EM::Connection

  def self.listen opts, &blk
    server = EM.start_server opts[:host], opts[:port], self, nil, opts, &blk
    server
  end

  def initialize(msg = nil, opts = {})
    @msg = msg
    @opts = opts
  end
  
  def post_init
    @buffer = BufferedTokenizer.new("\r")    
    @peer_port, @peer_host = Socket.unpack_sockaddr_in(get_peername)
  end
  
  def connection_completed
  end
  
  def each_line(&blk)
    @each_line_callback = blk
  end
  
  def receive_data data
    @buffer.extract(data).each do |line|
      puts "    Pong heard '#{line.chomp!}'"
      send_data "OK" + "\n\r"
      @each_line_callback.call(line)
    end
  end
  
  #TODO: really should handle if peer has already hung up
  def reply msg
    port, host = @peer_port, @peer_host
    puts "Pong replying to #{host}:#{port}..."
    send_data msg + "\n\r"
  end
  
end


EM.run {

  host = 'localhost'
  port = 5578
  
  puts "    Pong listening on #{host}:#{port}..."
  Pong.listen(:host => host, :port => port) do |server|
    server.each_line do |line|
      EM.add_timer(line.size) {
        server.reply line.tr('i','o')
      }
    end
  end

}