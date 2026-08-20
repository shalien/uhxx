import 'package:uhxx/src/builders/builder.dart';
import 'package:uhxx/src/builders/sentinels.dart';
import 'package:uhxx/src/models/guild/welcome_screen.dart';
import 'package:uhxx/src/utils/building_helpers.dart';

/// {@category builders}
class WelcomeScreenUpdateBuilder extends UpdateBuilder<WelcomeScreen> {
  bool? isEnabled;

  List<WelcomeScreenChannel>? channels;

  String? description;

  WelcomeScreenUpdateBuilder(
      {this.isEnabled, this.channels, this.description = sentinelString});

  @override
  Map<String, Object?> build() => {
        if (isEnabled != null) 'enabled': isEnabled,
        if (channels != null)
          'channels': [
            for (final channel in channels!)
              {
                'channel_id': channel.channelId.toString(),
                'description': channel.description,
                ...makeEmojiMap(
                    emojiId: channel.emojiId, emojiName: channel.emojiName),
              },
          ],
        if (!identical(description, sentinelString)) 'description': description,
      };
}
