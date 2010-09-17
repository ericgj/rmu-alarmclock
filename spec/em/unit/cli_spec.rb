require File.join(File.dirname(__FILE__),'..','..','helper')
require 'baconmocha'
require 'eventmachine'

require 'lib/em/em_client'

module CLISpecHelper

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
  
  #
  # These are designed to run a dummy server in a separate thread
  # For testing within the EM reactor instead of stubbing it
  #
  def self.start_server_thread(klass, host, port)
    Thread.new {
      EM.run {
          EM.start_server(host, port, klass)
        }
    }
  end
  
  def self.stop_server_thread(th)
    th.wakeup
    EM.stop
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

end


# Note: No EM reactor needed

describe 'CLI', 'parse' do

  describe 'when no arguments' do
  
  end
  
  describe 'when 1 argument' do
  
  end
  
  describe 'when 2 arguments' do
  
  end
  
  describe 'when 3 arguments' do
  
  end
  
end

# Note: EM reactor stubbed

describe 'CLI::ReminderClient' do
    
  it 'it should call send_data with the initial data in post_init' do
    @subject = CLISpecHelper.stub_connection(
                CLI::ReminderClient, "data", 
                :stubs => Proc.new { |stub|
                             stub.expects(:send_data).with("data").once
                           }
               )
  end
  
  it 'it should call close_connection_after_writing in post_init' do
    @subject = CLISpecHelper.stub_connection(
                CLI::ReminderClient, "data", 
                :stubs => :close_connection_after_writing
               )
  end
  
  it 'should stop the EM reactor when unbinding' do
    @subject = CLISpecHelper.stub_connection(
                CLI::ReminderClient, "data"
               ) { |conn|  EM.expects(:stop); conn.unbind }
  end
  
end

# Note: actual EM reactor run, dummy server listening on socket (on separate thread)

describe 'CLI', 'run' do
    
  describe 'when server is listening' do
    before do
      @server_thread = CLISpecHelper.start_server_thread(
                         CLISpecHelper::DummyServer,
                         '127.0.0.1', 5544
                       )
    end
    
    after do
      CLISpecHelper.stop_server_thread(@server_thread)
    end
    
    it 'should run without errors' do
      @client_thread = Thread.current
      EM.run {
        EM.next_tick { CLI.run }
        @client_thread.wakeup
        true.should.eql true
      }
    end
  end
    
end

