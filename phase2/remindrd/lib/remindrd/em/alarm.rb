module Remindrd
  module EM
    class Alarm < EventMachine::Connection

      DEFAULT_OPTIONS = {
        :reconnect => 10,
        :snooze => 5*60,
        :host => 'localhost',
        :port => 5578
      }
      
      def self.set_protocol(name)
        include Object.const_get("Remindrd::EM::Protocols::#{name.to_s}")
      end
      
      def self.each_response(&blk)
        @each_response_callback = blk
      end
      
      def self.trigger(message = nil, opts = {})
        connection = EM.connect opts[:host], opts[:port], self, message, opts
        connection
      end

      def initialize(message, opts = {})
        @message = message || DEFAULT_MESSAGE
        @opts = DEFAULT_OPTIONS.merge(opts)
      end
      
      def post_init
        reset_state
      end
      
      def connection_completed
        send_data dump(@message)
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
         
      def off!
        @state = :off
      end
      
      def snooze!
        @state = :snooze
      end
      
      def off?; @state == :off; end
      
      def snoozed?; @state == :snoozed; end
      
      
      def receive_data data
        @buffer.extract(data).each do |line|
          @each_response_callback.call(load(line)) \
            if @each_response_callback
        end
      end
      
      # overwrite in included protocol
      def load line
        line
      end
      
      # overwrite in included protocol
      def dump msg
        msg
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
end