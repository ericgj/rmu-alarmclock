require 'json'

class Reminder

  attr_reader :created_at, :start_at, :duration, :message

  def seconds_remaining  
    @duration - (Time.now - @start_at)
  end
  
  def initialize(hash)
    @created_at =  hash['created_at']
    @start_at   =  hash['start_at'] || hash['created_at']
    @duration   =  hash['duration']
    @message    =  hash['message'] || default_message
  end
  
  def default_message
    'Here\'s your wake-up call!!'
  end
  
  def to_h
    { 'created_at' => @created_at,
      'start_at' => @start_at,
      'duration' => @duration,
      'message' => @message
    }
  end
  
  def to_json
    to_h.to_json
  end
  
end
