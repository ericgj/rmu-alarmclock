require 'json'
require 'json/add/core'

class Reminder < Struct.new(:created_at, :start_at, :duration, :message, :timer_id)

  DEFAULT = { 'duration'   => 0,
              'message'    => 'Here\'s your wake-up call!!'
            }
            
  def seconds_remaining_to_start
    start_at - Time.now
  end
  
  def seconds_remaining  
    duration - (Time.now - start_at)
  end
  
  def state
    if seconds_remaining < 0
      :expired 
    elsif seconds_remaining_to_start < 0
      :started
    else
      :created
    end
  end
  
  def initialize(hash = {})
    hash = DEFAULT.merge(hash)
    hash['created_at'] ||= Time.now
    hash['start_at']   ||= hash['created_at']
    hash.each_pair {|k,v| self.__send__("#{k}=".to_sym, v)}
  end
 
  def to_h
    hash = {}
    each_pair {|k, v| hash[k] = v}
    hash
  end
  
  def to_json
    to_h.to_json
  end
  
end
