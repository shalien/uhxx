import 'package:uhxx/src/builders/builder.dart';
import 'package:uhxx/src/models/permission_overwrite.dart';
import 'package:uhxx/src/models/permissions.dart';
import 'package:uhxx/src/models/snowflake.dart';
import 'package:uhxx/src/utils/flags.dart';

/// {@category builders}
class PermissionOverwriteBuilder extends CreateBuilder<PermissionOverwrite> {
  Snowflake id;

  PermissionOverwriteType type;

  Flags<Permissions>? allow;

  Flags<Permissions>? deny;

  PermissionOverwriteBuilder(
      {required this.id, required this.type, this.allow, this.deny});

  @override
  Map<String, Object?> build({bool includeId = true}) => {
        if (includeId) 'id': id.toString(),
        'type': type.value,
        if (allow != null) 'allow': allow!.value.toString(),
        if (deny != null) 'deny': deny!.value.toString(),
      };
}
