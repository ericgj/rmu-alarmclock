require 'eventmachine'

module ReminderServer
  
  require 'json'
  
  def post_init
    @buffer = BufferedTokenizer.new("\r")
  end
  
  def unparseable_command(&blk)
    @unparseable_command_callback = blk
  end
  
  def each_reminder(&blk)
    @each_reminder_callback = blk
  end
  
  def receive_data data
    @buffer.extract(data).each do |line|
      receive_line line
    end
  end
  

  protected
  
  def receive_line line
    if line[0,1] == '{'
      begin
        schedule(parse(line))
      rescue
        @unparseable_command_callback.call(@buffer) \
          if @unparseable_command_callback
      end
    end
  end
  
  def parse msg
    Reminder.new(JSON.parse(msg))
  end
  
  def schedule reminder
    d = [reminder.seconds_remaining, 0.1].max
    if @each_reminder_callback
      EM.add_timer(d) do
        @each_reminder_callback.call(reminder)
      end
    end
  end
  
end



