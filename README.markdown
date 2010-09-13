## Description

Basically the project is a glorified alarm clock, or the 'reminder' part of a calendar application.  You tell a server you have an event at a given time and/or given duration and it sends you a reminder at the point in time the event is due to start or end (or at some configurable duration before).  You can snooze the reminder (for some configurable duration), or turn it off.  You can have multiple reminders going at once.  

There are basically three components:

- the 'client' which sends user event requests to
- the 'server' which keeps track of when reminders are due and sends them to
- the 'alarm' which notifies the user in some way and sends user 'snooze' or 'off' requests to the server

The main constraints are

1. The interface for setting up reminders has to be almost as easy as turning the dial of an egg timer;
2. The communication between the client requesting a reminder and the server sending the reminder is asynchronous;
3. The alarm mechanism (on the client side) should be able to be 'obtrusive', and not necessarily run in the same process as the client program that sends reminder requests to the server; but
4. The default alarm mechanism should be something very basic that makes few assumptions about what software the client has installed.


## Interface

The client interface is via command line.

Examples:

    remindr 10                          # generic reminder in 10 minutes
    remindr 30s                         # reminder in 30 seconds
    remindr 25 get up and stretch       # message reminder
    remindr 10:30 walk the dog          # reminder at specified time
    remindr --end 11pm-12:30pm meeting  # reminder at end of timed event
    
