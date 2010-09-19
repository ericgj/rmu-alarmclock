module ReminderServer
  include EM::Protocols::JSON::Simple
  
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
    d = [reminder.seconds_remaining, 0.1].max
    if @each_reminder_callback
      EM.add_timer(d) do
        @each_reminder_callback.call(reminder)
      end
    end
  end
  
end



