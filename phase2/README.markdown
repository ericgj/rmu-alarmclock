## Sinatra/Thin implementation
### initial notes

This is the second stage of the project, re-implementing the alarm clock using a 'skinny daemon' as the server part (Sinatra app running on local Thin webserver).

As of Sept 27, this stage is in its infancy.  Of the three parts of the application (client, server, and alarm), only the server part is sketched (`lib/remindrd`).

## Basic proposed flow through the system

The client piece here is a http client that can POST a reminder, encoded as JSON, to `/reminders`.  

The Sinatra app handles this route by saving the reminder, which triggers it to schedule a callback at the time the reminder is due (the 'alarm callback').

The alarm callback, defined within a configure block of the Sinatra app, creates an asynchronous EM connection to the alarm server which reconnects until it receives a response from the alarm server that turns it off.

It's worth quoting this code as it summarizes the work that the server piece does:

      # communicate with the alarm mechanism using JSON, no headers
      Remindrd::EM::Alarm.set_protocol :SimpleJSON
      
      # each time an alarm is scheduled to go off, 
      Reminder.alarm do |reminder|  
      
        # open a connection to the alarm server
        alarm = Remindrd::EM::Alarm.trigger(reminder)
        
        # and handle responses from the alarm server
        # which dictate whether and how frequently
        # the connection will be re-connected        
        alarm.each_response do |hash|
          resp = ReminderResponse.new(hash)
          alarm.snooze! if resp.snooze?
          alarm.off! if resp.off?
        end
        
      end
      

## The alarm mechanism

It's become increasingly obvious to me that the exact nature of the communication with the alarm mechanism has to be worked out before much else is done.  

For instance if we are talking about something like Growl, how are callbacks implemented and is the communication synchronous or async?  Which side is expected to hang up? etc.