## Eventmachine implementation

This is the first stage of the project, the Eventmachine implementation.

For explanation, see [http://github.com/ericgj/rmu-alarmclock/blob/master/ROADMAP.markdown](ROADMAP)

### How to run the tests

First make sure you have all the necessary gems.  Go to the project root (not 'phase1', but the level above). Run `bundle update`.

Then from the 'phase1' root, `rake`. Or `rake test:unit` to run unit tests, `rake test:functional` for functional tests.

For an explanation of what unit and functional tests are all about in the context of this project, see README files under spec/em/unit and spec/em/functional.

Note the tests aren't that thorough (as of Sept 21).


### How to run the app 
(as of Sept 26)

Right now the three parts of the app (the client, server, and alarm) are launched separately.  The plan is to daemonize the server and alarm components to make it easier.

Open up three bash shells and go to the 'phase1' root.  Enter these commands in two of the shells:

    bin/remindrd
    bin/alarmd
    
This will start up the reminder and alarm servers.  If it's the first time running, you will be prompted to set the configuration -- choose all default settings.  (It will save these to the file `~/.remindr` for the next time).

In the third shell, enter a command for setting the reminder. Right now the command syntax is very basic, it only accepts (1) a number of seconds to the alarm and (2) an optional message.

So to set a timer for two minutes with a message, enter:

    bin/remindr 120 We have liftoff!
    
In approximately two minutes, you should see the message appear in the `alarmd` shell, and it will attempt to play a sound.  (You need the `esound` client and server components installed to play the sound).

Then after this, every 10 seconds the message and sound will appear.

Eventually, the idea is that the user will be able to send a message back to the reminder server (perhaps through the alarm server), telling it to turn off the alarm or to snooze it.

For now, the only way to stop the alarm is to stop the `alarmd` or `remindrd` processes.

