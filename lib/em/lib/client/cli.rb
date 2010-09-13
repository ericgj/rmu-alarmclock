# TODO config APPENV with external file
APPENV = { 'host' => 'localhost',
           'port' => 5544
         }

# Usage:
#  CLI.run(ARGV)

module CLI

  def self.parse(*args)
    msg = Reminder.new( {
                   'duration' => args.shift,
                   'message'  => args.join(' '),
                   'created_at' => Time.now
                  }
                ).to_json
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

