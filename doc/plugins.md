Plugins provide a structured way for code to access a `uhxx` client, as well as
allowing HTTP requests and Gateway events to be intercepted.

To create your own plugin, create a subclass of [UhxxPlugin] and specify the
type of client the plugin can be used with in the type parameter. Plugins that
have per-client state should override [UhxxPlugin.createState] and return a
subclass of [UhxxPluginState]. The methods in [UhxxPlugin] and [UhxxPluginState]
can then be overridden to execute code at various points of the client
lifecycle.

Plugins can be added to clients using [ClientOptions.plugins].

Uhxx also comes with [some prebuilt plugins](#properties).

[UhxxPlugin]: ../uhxx/UhxxPlugin-class.html
[UhxxPlugin.createState]: ../uhxx/UhxxPlugin/createState.html
[UhxxPluginState]: ../uhxx/UhxxPluginState-class.html
[ClientOptions.plugins]: ../uhxx/ClientOptions/plugins.html
