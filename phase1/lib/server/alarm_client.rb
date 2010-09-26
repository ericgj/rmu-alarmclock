# This client sends the reminder and hangs up.
# Then it reconnects & sends again after the :reconnect option (seconds).
#
# Eventually the idea is to listen for a response from the remote (alarm) server,
#   and use that to determine whether to off or snooze the alarm, or continue
#   the annoying reminder every 10 seconds.

module Remindr
  class AlarmClient < ::EM::Connection
   
      DEFAULT_OPTIONS = {
        :reconnect => 10,
        :snooze => 5*60,
        :host => 'localhost',
        :port => 5578
      }
      
    def self.trigger(message = nil, opts = {})
      message = message || DEFAULT_MESSAGE
      opts = DEFAULT_OPTIONS.merge(opts)
      connection = EM.connect opts[:host], opts[:port], self, message, opts
      connection
    end
  
    def initialize(message, opts = {})
      @message = message
      @opts = opts
    end
      
    def post_init
      reset_state
    end
    
    def connection_completed
      send_data dump(@message)
      close_connection_after_writing
    end

    def unbind
      case @state
      when :off
      when :snoozed
        schedule_reconnect(@opts[:snooze])
      else
        schedule_reconnect(@opts[:reconnect])
      end
    end
       
       
    def dump msg
      msg.to_json + "\n\r"
    end
    
    protected
    
    def reset_state
      @buffer  = BufferedTokenizer.new("\r")
      @state = :init
    end
    
    def schedule_reconnect secs
      EM.add_timer(secs) do
        reconnect @opts[:host], @opts[:port]
      end
    end
          
    
  end
end
