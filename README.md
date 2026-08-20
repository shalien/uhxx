# uhxx

[![Discord](https://discordapp.com/api/guilds/846136758470443069/widget.png?style=shield)](https://discord.gg/uhxx)
[![pub](https://img.shields.io/pub/v/uhxx.svg)](https://pub.dev/packages/uhxx)
[![documentation](https://img.shields.io/badge/Documentation-uhxx-yellow.svg)](https://pub.dev/documentation/uhxx/latest/)

A complete, robust and efficient wrapper around Discord's API for bots & applications.

To get started using uhxx, follow our [getting started guide](https://uhxx.org/tutorials/writing_your_first_bot) to write your first bot.

If you're already familiar with Discord's API, here's a quick example to get you started:
```dart
import 'package:uhxx/uhxx.dart';

void main() async {
  final client = await Uhxx.connectGateway('<TOKEN>', GatewayIntents.allUnprivileged);

  final botUser = await client.users.fetchCurrentUser();

  client.onMessageCreate.listen((event) async {
    if (event.mentions.contains(botUser)) {
      await event.message.channel.sendMessage(MessageBuilder(
        content: 'You mentioned me!',
        referencedMessage: MessageReferenceBuilder.reply(messageId: event.message.id),
      ));
    }
  });
}
```

## Other uhxx packages

- [uhxx_commands](https://pub.dev/packages/uhxx_commands): A command framework for handling both simple & complex commands.
- [uhxx_extensions](https://pub.dev/packages/uhxx_extensions): Pagination, emoji utilities and other miscellaneous helpers for developing bots using uhxx.
- [uhxx_lavalink](https://pub.dev/packages/uhxx_lavalink): Lavalink support for playing audio in voice channels.

## More examples

- More examples can be found in our GitHub repository [here](https://github.com/uhxx-discord/uhxx/tree/main/example).
- [Running on Dart](https://github.com/uhxx-discord/running_on_dart) is a complete example of a bot written with uhxx.

## Additional documentation & help

The API documentation for the latest stable version can be found on [pub](https://pub.dev/documentation/uhxx).

### [Docs and wiki](https://uhxx.org)
Tutorials and wiki articles are hosted here.

### [Official uhxx Discord server](https://discord.gg/uhxx)
Our Discord server is where you can get help for any uhxx packages, as well as release announcements and discussions about the library.

### [Discord API docs](https://discord.dev/)
Discord's API documentation details what uhxx implements & provides more detailed explanations of certain topics.

### [Discord API Server](https://discord.gg/discord-api)
The unofficial guild for Discord Bot developers. To get help with uhxx check `#dart_uhxx` channel.

### [Pub.dev docs](https://pub.dev/documentation/uhxx)
The dartdocs page will always have the documentation for the latest release.

## Contributing to Uhxx

Read the [contributing document](https://github.com/uhxx-discord/uhxx/blob/dev/CONTRIBUTING.md)

## Credits 

- Thanks to [Hackzzila's](https://github.com/Hackzzila) for [nyx](https://github.com/Hackzzila/nyx), the original project uhxx was forked from.
