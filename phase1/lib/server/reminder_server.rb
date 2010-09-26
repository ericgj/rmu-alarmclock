
module Remindr
  module Server
    include Remindr::EMProtocols::SimpleJSONServer
    
    def self.start(host, port, &blk)
      EM.start_server(host, port, self, &blk)
    end

    def each_reminder(&blk)
      @each_reminder_callback = blk
    end

    def parse line
      Reminder.new(JSON.parse(line))
    end
    
    def receive_message msg
      schedule(msg)
    end
    
    protected
    
    def schedule reminder
      d0 = reminder.seconds_remaining_to_start
      d1 = reminder.seconds_remaining
      
      if @each_reminder_callback
      
        # note only set 'start' reminder if start time hasn't passed
        EM.add_timer(d0) do
          @each_reminder_callback.call(reminder)
        end if d0 > 0

        # if end time has passed, set end reminder immediately (0.01 sec)
        EM.add_timer([d1, 0.01].max) do
          @each_reminder_callback.call(reminder)
        end
        
      end
    end
    
  end
end


