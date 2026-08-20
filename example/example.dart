import 'dart:io';

import 'package:uhxx/uhxx.dart';

void main() async {
  final client = await Uhxx.connectGateway(
    Platform.environment['TOKEN']!,
    GatewayIntents.allUnprivileged,
    options: GatewayClientOptions(plugins: [logging, cliIntegration]),
  );

  await for (final MessageCreateEvent(:message) in client.onMessageCreate) {
    print(
        '${message.id} sent by ${message.author.id} in ${message.channelId}!');
  }
}
