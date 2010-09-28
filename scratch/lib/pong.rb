# This is part of a sample asynchronous interaction
# to mimic Growl (GNTP) interactions.
#
# Pong plays the part of the GNTP server. 
# It listens for connections, and responds to the peer both 
#       synchronously  (send_data within receive_data)
#   and asynchronously  (reply within EM.add_timer).
# It does not hang up either the incoming or outgoing connection.
# 
# Ping plays the part of the GNTP client.
# It connects to the server and sends messages while listening
#   for responses (synchronous).
# Once a response is received it hangs up and starts 
#   a new instance listening for responses (asynchronous).
# A new listener is only started the first time, ie. when the
#   client initially sends a message.  This is done assuming
#   only one asynchronous response (~ GNTP callback) from the server.
#
#
require 'rubygems'
require 'eventmachine'
require 'socket'

class Pong  < EM::Connection

  def self.listen opts, &blk
    server = EM.start_server opts[:host], opts[:port], self, nil, opts, &blk
    server
  end
  
  def self.reply msg, opts, &blk
    client = EM.connect opts[:host], opts[:port], self, msg, opts, &blk
    client
  end
  
  def initialize(msg = nil, opts = {})
    @msg = msg
    @opts = opts
  end
  
  def post_init
    @buffer = BufferedTokenizer.new("\r")    
    @peer_port, @peer_host = Socket.unpack_sockaddr_in(get_peername)
    if @msg
      puts "Pong said '#{@msg}'"
      send_data @msg + "\n\r"
    end
  end
  
  def connection_completed
  end
  
  def each_line(&blk)
    @each_line_callback = blk
  end
  
  def receive_data data
    @buffer.extract(data).each do |line|
      puts "Pong heard '#{line.chomp!}'"
      send_data line + "\n\r"
      @each_line_callback.call(line)
    end
  end
  
  def reply msg
    port, host = @peer_port, @peer_host
    puts "Pong replying to #{host}:#{port}..."
    Pong.reply msg, :host => host, :port => port 
  end
  
end


EM.run {

  host = '127.0.0.1'
  port = 5578
  
  puts "Pong listening on #{host}:#{port}..."
  Pong.listen(:host => host, :port => port) do |server|
    server.each_line do |line|
      EM.add_timer(line.size) {
        server.reply line.tr('i','o')
      }
    end
  end

}