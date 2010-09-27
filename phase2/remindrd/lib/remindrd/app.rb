require 'sinatra/base'

module Remindrd
  class App < Sinatra::Base

    #---- Dbase config
    
    configure :development do
      db = "sqlite3:///#{Dir.pwd}/development.sqlite3"
      DataMapper::Logger.new(STDOUT, :debug)
      DataMapper.setup(:default, db)
    end

    configure :test do
      db = "sqlite3::memory:"
      DataMapper.setup(:default, db)
    end

    configure :production, :test, :development do
      Reminder.auto_migrate! unless Reminder.storage_exists?
    end

    configure do
      Remindrd::EM::Alarm.set_protocol :SimpleJSON
      
      Reminder.alarm do |reminder|  
        alarm = Remindrd::EM::Alarm.trigger(reminder)
        alarm.each_response do |hash|
          resp = ReminderResponse.new(hash)
          alarm.snooze! if resp.snooze?
          alarm.off! if resp.off?
        end        
      end
      
    end
    
    #---- REST paths
    
    get '/' do
      "Reminder server is running: #{Reminder.started} current reminders"
    end
    
    get '/reminders/:id' do |id|
      rem = Reminder.get(id)
      rem.to_json
    end

    post '/reminders' do
      rem = Reminder.new(params[:reminder])
      if rem.save
        redirect "/reminders/#{rem.id}"
      else
        # render error
      end
    end
    

  end
end