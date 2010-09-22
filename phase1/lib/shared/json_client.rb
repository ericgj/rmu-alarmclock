require 'eventmachine'
require 'json'
require 'json/add/core'

# This is a generic async EM client for sending simple JSON messages
# with no header lines.

module EM
module Protocols
module JSON
module Simple
module Client
  
  def self.connect(host, port, reminder)
    EM.connect(host, port, self, reminder)
  end  
  
  def initialize(reminder)
    @reminder = reminder
  end
  
  def post_init
    send_data @reminder.to_json + "\n\r"
    close_connection_after_writing
  end
    
end
end
end
end
end