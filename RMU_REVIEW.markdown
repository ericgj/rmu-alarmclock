(For basic description of the project, see README).

## Roadmap

**The first stage** of this project is a simple implementation of all three parts of the app: client, server, and alarm, using straight Eventmachine.

By simple I mean:

- The most basic form of the command
- No mechanism for snoozing/offing alarms

As of Sept 27, the first stage is mostly completed, and works, although the test coverage is not very comprehensive.  See phase1/README for more details.

**The second stage** of the project is to re-do the app as a 'skinny daemon'.

This stage is only sketched as of Sept 27.  See phase2/README for more details.

**The third stage** of the project (planned) is to evaluate the two implementations and to integrate Growl into one or the other as the alarm/snoozing mechanism.

**The fourth stage** (planned) is to refine the command syntax.


