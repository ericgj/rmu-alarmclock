require 'eventmachine'
require 'json'
require 'json/add/core'

#TODO: refactor this and ReminderServer to extract common methods
#      for dealing with json messages
#
module SimpleAlarmClient
  
  def self.connect(host, port, reminder)
    EM.connect(host, port, self, reminder)
  end
  
  def snooze(&blk)
    @snooze_callback ||= blk
  end
  
  def off(&blk)
    @off_callback ||= blk
  end
  
  def response(&blk)
    @response_callback ||= blk
  end
  
  
  def initialize(reminder)
    @reminder = reminder
  end
  
  def post_init
    @buffer = BufferedTokenizer.new("\r")
    send_data @reminder.to_json
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
        handle_response(parse(line))
      rescue
        @unparseable_command_callback.call(line) \
          if @unparseable_command_callback
      end
    else
      @invalid_message_callback.call(line) \
        if @invalid_message_callback
    end
  end
  
  
  def parse msg
    ReminderResponse.new(JSON.parse(msg))
  end
  
  def handle_response resp
    if resp.snooze
      @snooze_callback.call(resp) if @snooze_callback
    elsif resp.off
      @off_callback.call(resp) if @off_callback
    else
      @response_callback.call(resp) if @response_callback
    end
  end
  
end