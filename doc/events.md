This topic contains all the classes that represent events received from
Discord's Gateway API.

It does not contain the logic for connecting to the Gateway itself. For that,
see the [Gateway] topic.

There are two main types of events received from the Gateway:
- Most subclasses of [GatewayEvent] are relevant for controlling session state.
  These events are handled by `uhxx` internally, but you can listen to them
  using [Gateway.messages] and looking for [EventReceived] events.
- Subclasses of [DispatchEvent] are sent when Discord informs your client of
  some state changing, such as a [Message] being created or a [User] updating
  their [Activity]. To listen for [DispatchEvent]s, use the [Gateway.events]
  stream, or one of the event-specific streams available on [UhxxGateway]
  (`client.onXXXEvent`). Note that only [RawDispatchEvent]s that have not been
  parsed will be emitted on the [Gateway.messages] stream.

To control which [DispatchEvent]s your client receives, please see
[GatewayApiOptions.intents].

[Gateway]: ./gateway-topic.html
[GatewayEvent]: ../uhxx/GatewayEvent-class.html
[Gateway.messages]: ../uhxx/Gateway/messages.html
[EventReceived]: ../uhxx/EventReceived-class.html
[DispatchEvent]: ../uhxx/DispatchEvent-class.html
[Message]: ../uhxx/Message-class.html
[User]: ../uhxx/User-class.html
[Activity]: ../uhxx/Activity-class.html
[Gateway.events]: ../uhxx/Gateway/events.html
[UhxxGateway]: ../uhxx/UhxxGateway-class.html
[RawDispatchEvent]: ../uhxx/RawDispatchEvent-class.html
[GatewayApiOptions.intents]: ../uhxx/GatewayApiOptions/intents.html
