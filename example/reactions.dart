import 'dart:io';

import 'package:uhxx/uhxx.dart';

void main() async {
  final client = await Uhxx.connectGateway(
    Platform.environment['TOKEN']!,
    GatewayIntents.allUnprivileged | GatewayIntents.messageContent,
    options: GatewayClientOptions(plugins: [logging, cliIntegration]),
  );

  client.onMessageCreate.listen((event) async {
    if (event.message.content.contains('uhxx')) {
      await event.message.react(ReactionBuilder(name: '❤️', id: null));
    }
  });
}
