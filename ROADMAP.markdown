## Roadmap

**The first stage** of this project I want to do is a simple implementation of all three parts of the app: client, server, and alarm, using straight Eventmachine.

By simple I mean:

- The most basic form of the command
- No mechanism for snoozing/offing alarms

### As of Sept 19, the first stage is mostly completed.  See lib/em/README for more details.

**The second stage** of the project is to re-do the app as a 'skinny daemon'.

**The third stage** of the project is to evaluate the two implementations and to integrate Growl into one or the other as the alarm/snoozing mechanism.

**The fourth stage** is to refine the command syntax.