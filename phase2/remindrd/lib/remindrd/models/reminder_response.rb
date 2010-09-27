
class ReminderResponse < Struct(:response, :reminder)

  def initialize(hash)
    reminder = Reminder.new(r) if r = hash.delete('reminder')
    hash.each_pair {|k,v| self.__send__("#{k}=".to_sym, v)}    
  end
  
  def snooze?
    (response == 'snooze')
  end
  
  def off?
    (response == 'off')
  end
  
end
