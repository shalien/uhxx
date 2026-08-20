import 'package:uhxx/src/builders/builder.dart';
import 'package:uhxx/src/builders/sentinels.dart';
import 'package:uhxx/src/builders/sound.dart';
import 'package:uhxx/src/models/snowflake.dart';
import 'package:uhxx/src/models/soundboard/soundboard.dart';
import 'package:uhxx/src/utils/building_helpers.dart';

/// {@category builders}
class SoundboardSoundBuilder extends CreateBuilder<SoundboardSound> {
  String name;

  SoundBuilder sound;

  double? volume;

  String? emojiName;

  Snowflake? emojiId;

  SoundboardSoundBuilder(
      {required this.name,
      required this.sound,
      this.volume,
      this.emojiName,
      this.emojiId});

  @override
  Map<String, Object?> build() => {
        'name': name,
        'sound': sound.buildDataString(),
        if (volume != null) 'volume': volume,
        ...makeEmojiMap(emojiId: emojiId, emojiName: emojiName),
      };
}

/// {@category builders}
class SoundboardSoundUpdateBuilder extends UpdateBuilder<SoundboardSound> {
  String name;

  double? volume;

  String? emojiName;

  Snowflake? emojiId;

  SoundboardSoundUpdateBuilder(
      {required this.name,
      this.volume = sentinelDouble,
      this.emojiName = sentinelString,
      this.emojiId = sentinelSnowflake});

  @override
  Map<String, Object?> build() => {
        'name': name,
        if (volume != sentinelDouble) 'volume': volume,
        if (!(identical(emojiName, sentinelString) ||
            identical(emojiId, sentinelSnowflake)))
          ...makeEmojiMap(emojiId: emojiId, emojiName: emojiName),
      };
}
