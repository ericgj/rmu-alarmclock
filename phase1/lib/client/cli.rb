require 'eventmachine'
require 'json'
require 'json/add/core'

# Usage:
#  Remindr::CLI.run(host, port, ARGV)

module Remindr
module CLI
  
  def self.parse(*args)
    args = args.flatten
    h = {}
    h['duration'] = (args.shift).to_i
    h['message'] = args.join(' ')  unless args.empty?
    h['created_at'] = Time.now
    msg = Reminder.new(h)
  end
  
  def self.run(host, port, *args)
    EM.run { 
      msg = CLI.parse(*args)
      EM.connect host, port, ReminderClient, msg
    }
  end
  
  module ReminderClient
    include ::EM::Protocols::JSON::Simple::Client

    def unbind
      EM.stop
    end
    
  end
  
end
end