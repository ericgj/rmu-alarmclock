# TODO config APPENV with external file
APPENV = { 'host' => '127.0.0.1',
           'port' => 5544
         }

# Usage:
#  CLI.run(ARGV)

module CLI

  def self.parse(*args)
    h = {}
    h['duration'] = arg0           if (arg0 = args.shift)
    h['message'] = args.join(' ')  unless args.empty?
    h['created_at'] = Time.now
    msg = Reminder.new(h).to_json
  end
  
  def self.run(*args)
    EM.run { 
      EM.connect APPENV['host'], APPENV['port'], ReminderClient, CLI.parse(*args)
    }
  end
  
  module ReminderClient

    def initialize(reminder)
      @msg = reminder
    end
    
    def post_init
      send_data msg
      close_connection_after_writing
    end
    
    def unbind
      EM.stop
    end
    
  end
  
end

