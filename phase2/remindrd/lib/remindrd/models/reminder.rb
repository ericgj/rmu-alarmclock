
class Reminder
  include DataMapper::Resource
  
  property :id, Serial
  property :start_at, Time
  property :duration, Integer
  property :message, String
  property :timer_id, String
  
  before_save :schedule
  
  def self.started
    all {|r| r.state == :started}
  end
  
  attr_reader :alarm_callback
  
  def self.alarm(&blk)
    @alarm_callback = blk
  end
  
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

  def to_json
    # does DM give us this?
  end
  
  private 
  
  def schedule
    # TODO raise error if EM not running
    
    d0 = seconds_remaining_to_start
    d1 = seconds_remaining
    
    if cb = self.class.alarm_callback
      # note only set 'start' reminder if start time hasn't passed
      EM.add_timer(d0) do
        cb.call(reminder)
      end if d0 > 0

      # if end time has passed, set end reminder immediately (0.01 sec)
      EM.add_timer([d1, 0.01].max) do
        cb.call(reminder)
      end
    end
    
  end
  
end