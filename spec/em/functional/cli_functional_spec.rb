require File.join(File.dirname(__FILE__),'..','..','helper')
require File.join(File.dirname(__FILE__),'..','helper')

require 'lib/em/em_client'

# Note: actual EM reactor run, dummy server listening on socket (on separate thread)

describe 'CLI', 'run' do
    
  describe 'when server is listening' do
    before do
      @server_thread = EmSpecHelper.start_server_thread(
                         EmSpecHelper::DummyServer,
                         'localhost', 5544
                       )
    end
    
    after do
      EmSpecHelper.stop_server_thread(@server_thread)
    end
    
    it 'should run without errors' do
      @client_thread = Thread.current
      EM.run {
        EM.next_tick { CLI.run('localhost', 5544) }
        @client_thread.wakeup
        true.should.eql true
      }
    end
  end
    
end

