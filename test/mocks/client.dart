import 'package:mocktail/mocktail.dart';
import 'package:uhxx/uhxx.dart';
import 'package:uhxx/src/manager_mixin.dart';

import 'gateway.dart';

class MockUhxx with Mock, ManagerMixin implements UhxxRest {
  @override
  PartialApplication get application => applications[Snowflake.zero];

  @override
  PartialUser get user => users[Snowflake.zero];

  @override
  late final CacheManager cache = CacheManager(this);
}

class MockUhxxGateway with Mock, ManagerMixin implements UhxxGateway {
  @override
  Gateway get gateway => MockGateway();

  @override
  late final CacheManager cache = CacheManager(this);
}
