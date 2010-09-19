require 'json'
require 'json/add/core'

#TODO

class ReminderResponse < Struct.new(:response, :created_at, :duration, :reminder)

  def snooze
    response == 'snooze'
  end
  
  def off
    response == 'off'
  end
  
  
end