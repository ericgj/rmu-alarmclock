module Remindrd
  module EM
    class Alarm < EventMachine::Connection

      DEFAULT_OPTIONS = {
        :reconnect => 10,
        :snooze => 5*60,
        :host => 'localhost',
        :port => 5578
      }
      
      DEFAULT_REMINDER = Reminder.new
      
      def self.set_protocol(name)
        include Object.const_get("Remindrd::EM::Protocols::#{name.to_s}")
      end
      
      def self.each_response(&blk)
        @each_response_callback = blk
      end
      
      def self.trigger(reminder = nil, opts = {})
        reminder ||= DEFAULT_REMINDER
        opts = DEFAULT_OPTIONS.merge(opts)
        connection = ::EM.connect opts[:host], opts[:port], self, reminder, opts
        connection
      end

      def initialize(reminder, opts = {})
        @reminder = reminder
        @opts = opts
      end
      
      def post_init
        reset_state
      end
      
      def connection_completed
        send_data dump(@reminder) + "\n\r"
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
        @state = :snoozed
      end
            
      def receive_data data
        @buffer.extract(data).each do |line|
          @each_response_callback.call(load(line)) \
            if @each_response_callback
        end
      end
      
      # overwrite in included protocol
      def load line
        line.to_s
      end
      
      # overwrite in included protocol
      def dump msg
        msg.to_s
      end
      
      
      protected
      
      def reset_state
        @buffer  = BufferedTokenizer.new("\r")
        @state = :init
      end
      
      def schedule_reconnect secs
        ::EM.add_timer(secs) do
          reconnect @opts[:host], @opts[:port]
        end
      end
      
    end
  end
end