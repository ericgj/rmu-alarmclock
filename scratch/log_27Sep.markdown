## The alarm mechanism

Documentation for GNTP (Growl Network Transport Protocol) is here:
http://www.growlforwindows.com/gfw/help/gntp.aspx

(Don't ask me why the docs are only on the Windows implementation site.  I guess Mac developers just rely on the Cocoa tools and could care less about GNTP).

<blockquote>

Connection Handling

The default behavior for GNTP messages is for each request-response-callback combination to take place on a seperate socket connection. The sequence looks like this:

   1. Sending application opens a new socket
   2. Sending application sends request message
   3. Notification system receives request, handles it, and returns the response message
   4. Sending application receives the response. If no callback was specified, the socket connection is closed
   5. If a callback was requested, the notification system will use the original socket to return the callback message
   6. Sending application receive the callback and the socket connection is closed
   7. Each new request repeats this process

   Some applications may wish to reuse sockets instead of creating a new socket connection for each request. For this scenario, all request messages support an additional header:

`Connection: <[Close|Keep-Alive]>`

    Optional - If set to 'Keep-Alive', the socket connection can be reused by the sending application. Defaults to 'Close'

Note that the default behavior is the opposite of the way HTTP handles requets.

If the 'Connection' header is specified as 'Keep-Alive', all GNTP messages (requests, responses, and callbacks) must also include an end-of-message semaphore. After all message headers and any inline binary data, the following character sequence should be sent immediately before the usual GNTP message terminator (two `<CRLF>` sequences):

`GNTP/<version> END`

When reusing sockets, the sending application will be responsible for keeping track of which responses and callbacks are associated with which request. There are also important performance considerations to be aware of when choosing whether to reuse sockets. When sending requests with no inline binary data over high-latency connections, socket reuse can reduce the time it would have taken to renegotiate each connection. However, the receiving notification system is no longer able to read partial requests, so any inline binary data will never be eligible to be read from cache, significantly increasing the request transmission time.

Growl for Windows v2.0 does not yet support the 'Connection' header, socket reuse, or the GNTP/1.0 END semaphore.

</blockquote>


So translating this to our situation, ignoring the bit about reusing sockets, it sounds like our alarm client needs to:

1. convert the reminder to GNTP headers, including callback headers, and send_data to GNTP server;
2. receive_data back from the GNTP server and forward any callback received; close_connection either if no callback was specified in the original request, or after a callback is received.

At first I read the specs above as needing to _reopen connections within a single notification request_, ie. once for the synch response and once for the async, but now I see that connections are left open per request until the callback is received (if requested).  So it's fairly cut and dry.

It's surprising there is no async GNTP ruby library out there already.

