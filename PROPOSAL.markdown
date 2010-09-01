## Description

Basically the project is a glorified alarm clock, or the 'reminder' part of a calendar application.  You tell a server you have an event at a given time and/or given duration and it sends you a reminder at the point in time the event is due to start or end (or at some configurable duration before).  You can snooze the reminder (for some configurable duration), or turn it off.  You can have multiple reminders going at once.  

There are basically three components:

- the 'client' which sends user event requests to
- the 'server' which keeps track of when reminders are due and sends them to
- the 'alarm' which notifies the user in some way and sends user 'snooze' or 'off' requests to the server

The interactions may turn out to be a little different than this but that's the naive picture.

Note it isn't intended to be a full fledged calendar app with CRUD interface to the events, etc.  


## Motivations

Originally, the idea grew out of my need for a simple timer to use when programming instead of the egg timer or cell phone alarm I currently use.  Very useful tools to help pull one's head up out of whatever it's buried in!

I am not quite convinced there is a better mouse trap to build for the job than the egg timer.  Hard to beat the simplicity of that interface.  (In fact I'm not convinced the best solution for me is a software one at all, since the point of the reminder/alarm is to draw your attention up from the screen...) 

So I've come to see primary purpose of the project is a toy for exploring various Ruby technologies (see below), and of course for improving my programming practices.

The main constraints are

1. The interface for setting up reminders has to be almost as easy as turning the dial of an egg timer;
2. The communication between the client requesting a reminder and the server sending the reminder is asynchronous;
3. The alarm mechanism (on the client side) should be able to be 'obtrusive', and not necessarily run in the same process as the client program that sends reminder requests to the server; but
4. The default alarm mechanism should be something very basic that makes few assumptions about what software the client has installed.

I tried to stay within the guidelines of 'not too huge or challenging a project, but does something interesting or useful', but let me know what you think.


## What I am hoping to explore with this project

First of all I am looking forward to developing this project from the 'outside in' using **BDD** (although I'm plenty familiar with RSpec, I have just started actually doing BDD).

Initially the client interface would be from the command line, so I want to explore **approaches to and tools for implementing a CLI**.

The alarm mechanism is the most unsettled aspect of the project.  My thought is to first implement it as a simple spawned process that does not allow feedback back to the server, ie. doesn't allow 'snoozing'.  Further on I'd like to have it do something like run a **Shoes** app, or interface with something like **Growl** (which has a built-in callback mechanism).

As for the back end, I am not settled yet on using http, in any case I have two routes in mind, both utilizing asynchronous messaging to varying degrees.  Perhaps I could try both and see what are the dis/advantages of each.

- Client and server pieces each run within **EventMachine** reactors.  Client triggers alarm mechanism on receiving reminder from the server, and alarm runs within the client reactor although it may spawn external processes.

- Taking the approach detailed recently by [Head Labs](http://labs.headlondon.com/2010/07/skinny-daemons/), design the server piece as a 'skinny daemon' (RESTful **Sinatra/Rack** app running inside a **Thin** webserver on localhost). The client piece then would use **RestClient** or similar under the hood.  Since the server is running locally, it itself handles spawning the alarm mechanism from a timer callback.


## Potential extensions (not necessarily done within the deadlines of the course)

1. Persistence
2. Rescheduling
3. Multiuser
