
module EmSpecHelper

  # This is designed to work like EM.connect --
  #   it mixes the module into StubConnection below instead of EM::Connection.
  # It does *not* run within an EM reactor.  
  # The block passed it should set any expectations, and
  #    then call the callbacks being tested.
  # These will be called (synchronously of course) after post_init.
  # For example, to test that close_connection is called in :receive_data:
  #     stub_connection(MyRealClient, params) do |conn|
  #        conn.expects(:close_connection)
  #        conn.receive_data "200 OK"
  #     end
  #
  # If you want to test expectations in post_init, you can pass a :stubs proc:
  #     stub_connection(MyRealClient, params,
  #                     :stubs => Proc.new { |s| s.expects(:send_data).with("message") }
  #                    ) do |conn|
  #       conn.receive_data "200 OK"
  #     end
  #
  # Or more simply as an array if you don't care about parameters or return values:
  #     stub_connection(MyRealClient, params,
  #                     :stubs => [ :send_data ]
  #                    ) do |conn|
  #       conn.receive_data "200 OK"
  #     end
  #
  # If you don't set any expectations, the EM::Connection methods will 
  # simply quietly fire and return nil.
  #
  def self.stub_connection(klass, *args, &blk)
    Class.new(StubConnection){ include klass }.new(*args, &blk)
  end
  
  class StubConnection
  
    def self.new(*args)
      opts = args.last.is_a?(Hash) ? args.pop : {}
      stubs = opts[:stubs]
      allocate.instance_eval {
        # set expectations here
        case stubs
        when Symbol
          self.expects(stubs)
        when Array   # expect methods
          stubs.each {|sym| self.expects(sym.to_sym)}
        when Hash   # expect methods => returns
          stubs.each_pair {|sym, v| self.expects(sym.to_sym).returns(v)}
        else        # define more complicated stubs in a proc
          stubs.call(self) if stubs.respond_to?(:call)   
        end
        initialize(*args)
        post_init
        yield(self) if block_given?
        self
      }
    end
    
    def initialize(*args)
    end
    
    # stubbed methods => nil
    
    def send_data(data); nil; end
    def close_connection after_writing = false; nil; end
    def close_connection_after_writing; nil; end
    def proxy_incoming_to(conn,bufsize=0); nil; end
    def stop_proxying; nil; end
    def detach; nil; end
    def get_sock_opt level, option; nil; end
    def error?; nil; end
    def start_tls args={}; nil; end
    def get_peer_cert; nil; end
    def send_datagram data, recipient_address, recipient_port; nil; end
    def get_peername; nil; end
    def get_sockname; nil; end
    def get_pid; nil; end
    def get_status; nil; end
    def comm_inactivity_timeout; nil; end
    def comm_inactivity_timeout= value; nil; end
    def set_comm_inactivity_timeout value; nil; end
    def pending_connect_timeout; nil; end
    def pending_connect_timeout= value; nil; end
    def set_pending_connect_timeout value; nil; end
    def reconnect server, port; nil; end
    def send_file_data filename; nil; end
    def stream_file_data filename, args={}; nil; end
    def notify_readable= mode; nil; end
    def notify_readable?; nil; end
    def notify_writable= mode; nil; end
    def notify_writable?; nil; end
    def pause; nil; end
    def resume; nil; end
    def paused?; nil; end

    # no-op callbacks
    
    def post_init; end
    def receive_data data; end
    def connection_completed; end
    def ssl_handshake_completed; end
    def ssl_verify_peer(cert); end
    def unbind; end
    def proxy_target_unbound; end
    
  end


  class << self
    #
    # These are designed to run a dummy server in a separate thread
    # For testing within the EM reactor instead of stubbing it
    #
    def start_server_thread(klass, host, port)
      Thread.new {
        EM.run {
            EM.start_server(host, port, klass)
          }
      }
    end
      
    def stop_server_thread(th)
      th.wakeup
      EM.stop
    end

    def stop_connect_thread(th); th.wakeup; end

    def start_connect_thread(klass, host, port, data)
      Thread.new {
        EM.run {
          EM.connect(host, port, klass, data)
          #EM.next_tick { EM.stop }
        }
      }
    end
    
  end
    
  module DummyServer
    
    def initialize
      $stdout.print "Connection initializing\n"; $stdout.flush
    end
    
    def post_init
      $stdout.print "Connection initialized\n"; $stdout.flush
    end
    
    def receive_data data
      $stdout.print "Data received\n"; $stdout.flush
      close_connection
    end
    
  end

  module DummyClient
  
    def initialize(msg)
      @msg = msg
    end
    
    def post_init
      send_data @msg
      close_connection_after_writing
    end
    
  end
  
end