The classes in this topic provide the structure upon which the rest of the
library is built.

The central component of the `uhxx` library is the client: it encapsulates and
manages the lifecycle of several components that are responsible for accessing
the Discord API. All clients implement the [Uhxx] interface, and static methods
on that same class can be used to create specific client instances ([UhxxRest],
[UhxxOAuth2], or [UhxxGateway]).

Clients can be configured using [ApiOptions] and [ClientOptions]. Some clients
will be configured by a subtype of these configuration classes. [ApiOptions] are
used to configure how the client interacts with the Discord API itself, whereas
[ClientOptions] are used to configure client-side only behavior, such as plugins
and caching.

All clients will expose a [HttpHandler] that is used for performing HTTP
requests to the Discord API. For more information, see the [HTTP] topic.

Most users will not interact with the client's [HttpHandler], but will rather
use the [Managers] exposed by the client that provide deserialization for
[Models] and [Entities], as well as concrete Dart APIs corresponding to API
endpoints. Each [Manager] is usually attached to one or more kinds of [Entity],
and methods on [Entities] are usually just shortcuts to a corresponding
[Manager] method. For more information, see the [Managers] topic.

[Managers] also provide access to the client's caching system. While caches are
stored centrally in a [CacheManager], [Managers] are responsible for creating
and updating individual [Cache]s, which can be accessed directly via
[Manager.cache], by using the [Manager.get] method, or by using
[SnowflakeEntity.get] (which is a shorthand for [Manager.get]).

[Manager]s sometimes require the user to specify the structure of an entity to
create or update. While [Models] and [Entities] are received from the Discord
API, [Builders] allow users to create structures that are sent to the Discord
API. For more information, see the [Builders] topic.

Clients that connect to Discord's Gateway API do so using a
[Gateway](https://pub.dev/documentation/uhxx/latest/uhxx/Gateway-class.html)
instance. For more information on how the connection lifecycle is managed, see
the [Gateway] topic. For more information on the events the client can receive,
see the [Events] topic.

Finally, clients can be customized by [Plugins]. These provide a good way to
encapsulate functionality and `uhxx` comes with some built-in plugins. For more
information, see the [Plugins] topic.

[Uhxx]: ../uhxx/Uhxx-class.html
[UhxxRest]: ../uhxx/UhxxRest-class.html
[UhxxOAuth2]: ../uhxx/UhxxOAuth2-class.html
[UhxxGateway]: ../uhxx/UhxxGateway-class.html
[ApiOptions]: ../uhxx/ApiOptions-class.html
[ClientOptions]: ../uhxx/ClientOptions-class.html
[HttpHandler]: ../uhxx/HttpHandler-class.html
[HTTP]: ./http-topic.html
[Managers]: ./managers-topic.html
[Models]: ./models-topic.html
[Entities]: ./entities-topic.html
[Manager]: ../uhxx/Manager-class.html
[Entity]: ./entities-topic.html
[CacheManager]: ../uhxx/CacheManager-class.html
[Cache]: ../uhxx/Cache-class.html
[Manager.cache]: ../uhxx/ReadOnlyManager/cache.html
[Manager.get]: ../uhxx/ReadOnlyManager/get.html
[SnowflakeEntity.get]: ../uhxx/SnowflakeEntity/get.html
[Builders]: ./builders-topic.html
[Gateway]: ./gateway-topic.html
[Events]: ./events-topic.html
[Plugins]: ./plugins-topic.html
