require 'json'
require 'json/add/core'

# Usage:
#  CLI.run(host, port, ARGV)

module CLI
  
  def self.parse(*args)
    h = {}
    h['duration'] = arg0           if (arg0 = args.shift)
    h['message'] = args.join(' ')  unless args.empty?
    h['created_at'] = Time.now
    msg = Reminder.new(h)
  end
  
  def self.run(host, port, *args)
    EM.run { 
      EM.connect host, port, ReminderClient, CLI.parse(*args)
    }
  end
  
  module ReminderClient

    def initialize(reminder)
      @msg = reminder.to_json + "\n\r"
    end
    
    def post_init
      send_data @msg
      close_connection_after_writing
    end
    
    def unbind
      EM.stop
    end
    
  end
  
end

