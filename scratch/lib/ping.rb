# This is part of a sample asynchronous interaction
# to mimic Growl (GNTP) interactions.
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
# Pong plays the part of the GNTP server. 
# It listens for connections, and responds to the peer both 
#       synchronously  (send_data within receive_data)
#   and asynchronously  (reply within EM.add_timer).
# It does not hang up either the incoming or outgoing connection.
# 
#

require 'rubygems'
require 'eventmachine'
require 'socket'

class Ping < EM::Connection
  
  def self.trigger(msg, opts = {})
    connection = EM.connect opts[:host], opts[:port], self, msg, opts
    connection
  end
  
  def self.listen(opts = {})
    puts "Ping listening on #{opts[:host]}:#{opts[:port]}..."
    server = EM.start_server opts[:host], opts[:port], self, nil, opts
    server
  end
  
  def initialize(msg = nil, opts = {})
    super
    @msg = msg
    @opts = opts
  end
  
  def post_init
    @buffer = BufferedTokenizer.new("\r")
    @local_port, @local_host = Socket.unpack_sockaddr_in(get_sockname)
    if @msg
      puts "Ping said #{@msg}..."
      send_data @msg + "\n\r"
    end
  end
  
  def connection_completed
  end
  
  def receive_data data
    @buffer.extract(data).each do |line|
      puts "Heard back '#{line.chomp!}' (#{@msg ? 'synchronous' : 'asynchronous'})"
      if @msg
        port, host = @local_port, @local_host
        EM.next_tick { Ping.listen :host => host, :port => port }
      end
      close_connection_after_writing
    end
  end
  
  def unbind
  end
  
end


EM.run {

  EM.add_periodic_timer(5) {
  
    host = '127.0.0.1'
    port = 5578
    msg = ['it', 'rider', 'iris', 'thimble', 'yeti', 'cookie', 'flipper', 'i']
    
    Ping.trigger(msg[rand(msg.size-1)], :host => host, :port => port)
    
  }
}