import 'dart:async';

import 'package:logging/logging.dart';
import 'package:uhxx/src/builders/presence.dart';
import 'package:uhxx/src/builders/voice.dart';
import 'package:uhxx/src/cache/cache.dart';
import 'package:uhxx/src/client_options.dart';
import 'package:uhxx/src/errors.dart';
import 'package:uhxx/src/event_mixin.dart';
import 'package:uhxx/src/gateway/gateway.dart';
import 'package:uhxx/src/http/handler.dart';
import 'package:uhxx/src/http/managers/gateway_manager.dart';
import 'package:uhxx/src/intents.dart';
import 'package:uhxx/src/manager_mixin.dart';
import 'package:uhxx/src/api_options.dart';
import 'package:uhxx/src/models/application.dart';
import 'package:uhxx/src/models/guild/guild.dart';
import 'package:uhxx/src/models/snowflake.dart';
import 'package:uhxx/src/models/user/user.dart';
import 'package:uhxx/src/plugin/plugin.dart';
import 'package:uhxx/src/utils/flags.dart';
import 'package:oauth2/oauth2.dart';
import 'package:runtime_type/runtime_type.dart';

/// A helper function to nest and execute calls to plugin connect methods.
Future<T> _pluginConnect<T extends Uhxx>(
    ApiOptions apiOptions,
    ClientOptions clientOptions,
    Future<T> Function() connect,
    List<UhxxPlugin> plugins) {
  final actualClientType = RuntimeType<T>();

  for (final plugin in plugins) {
    if (!actualClientType.isSubtypeOf(plugin.clientType)) {
      throw PluginError(
          'Unsupported client type: plugin needs ${plugin.clientType.internalType}, client was ${actualClientType.internalType}');
    }
  }

  final originalConnect = connect;

  connect = plugins.fold(
    originalConnect,
    (previousConnect, plugin) => () async => actualClientType.castInstance(
        await plugin.doConnect(apiOptions, clientOptions, previousConnect)),
  );

  return connect();
}

/// A helper function to nest and execute calls to plugin close methods.
Future<void> _pluginClose(
    Uhxx client, Future<void> Function() close, List<UhxxPlugin> plugins) {
  close = plugins.fold(
    close,
    (previousClose, plugin) => () => plugin.doClose(client, previousClose),
  );
  return close();
}

/// The base class for clients interacting with the Discord API.
///
/// {@category core}
abstract class Uhxx {
  /// The options this client will use when connecting to the API.
  ApiOptions get apiOptions;

  /// The [HttpHandler] used by this client to make requests.
  HttpHandler get httpHandler;

  /// The options controlling the behavior of this client.
  ClientOptions get options;

  /// The logger for this client.
  Logger get logger => options.logger;

  /// The cache manager for this client.
  late final CacheManager cache = CacheManager(this);

  final Completer<void> _doneCompleter = Completer();
  bool _isClosed = false;

  /// Create an instance of [UhxxRest] that can perform requests to the HTTP API and is
  /// authenticated with a bot token.
  static Future<UhxxRest> connectRest(String token,
          {RestClientOptions options = const RestClientOptions()}) =>
      connectRestWithOptions(RestApiOptions(token: token), options);

  /// Create an instance of [UhxxRest] using the provided options.
  static Future<UhxxRest> connectRestWithOptions(RestApiOptions apiOptions,
      [RestClientOptions clientOptions = const RestClientOptions()]) async {
    return _pluginConnect(apiOptions, clientOptions, () async {
      clientOptions.logger
        ..info('Connecting to the REST API')
        ..fine(
            'Token: ${apiOptions.token}, Authorization: ${apiOptions.authorizationHeader}, User-Agent: ${apiOptions.userAgent}')
        ..fine(
            'Plugins: ${clientOptions.plugins.map((plugin) => plugin.name).join(', ')}');

      final client = UhxxRest._(apiOptions, clientOptions);

      client
        .._application = await client.applications.fetchCurrentApplication()
        .._user = await client.users.fetchCurrentUser();

      client.httpHandler.done.then((_) {
        if (client._doneCompleter.isCompleted) return;

        client._doneCompleter.completeError(
            UhxxException('HTTP handler was closed'), StackTrace.current);
        client.close();
      }, onError: (e, s) {
        if (client._doneCompleter.isCompleted) return;

        client._doneCompleter.completeError(e, s);
        client.close();
      });

      return client;
    }, clientOptions.plugins);
  }

  /// Create an instance of [UhxxOAuth2] that can perform requests to the HTTP API and is
  /// authenticated with OAuth2 [Credentials].
  ///
  /// Note that `client.user.id` will contain [Snowflake.zero] if there no `identify` scope.
  static Future<UhxxOAuth2> connectOAuth2(Credentials credentials,
          {RestClientOptions options = const RestClientOptions()}) =>
      connectOAuth2WithOptions(
          OAuth2ApiOptions(credentials: credentials), options);

  /// Create an instance of [UhxxOAuth2] using the provided options.
  ///
  /// Note that `client.user.id` will contain [Snowflake.zero] if there no `identify` scope.
  static Future<UhxxOAuth2> connectOAuth2WithOptions(
      OAuth2ApiOptions apiOptions,
      [RestClientOptions clientOptions = const RestClientOptions()]) async {
    return _pluginConnect(apiOptions, clientOptions, () async {
      clientOptions.logger
        ..info('Connecting to the REST API via OAuth2')
        ..fine(
            'Token: ${apiOptions.token}, Authorization: ${apiOptions.authorizationHeader}, User-Agent: ${apiOptions.userAgent}')
        ..fine(
            'Plugins: ${clientOptions.plugins.map((plugin) => plugin.name).join(', ')}');

      final client = UhxxOAuth2._(apiOptions, clientOptions);
      final information = await client.users.fetchCurrentOAuth2Information();

      client
        .._application = information.application
        .._user = information.user ??
            PartialUser(id: Snowflake.zero, manager: client.users);

      client.httpHandler.done.then((_) {
        if (client._doneCompleter.isCompleted) return;

        client._doneCompleter.completeError(
            UhxxException('HTTP handler was closed'), StackTrace.current);
        client.close();
      }, onError: (e, s) {
        if (client._doneCompleter.isCompleted) return;

        client._doneCompleter.completeError(e, s);
        client.close();
      });

      return client;
    }, clientOptions.plugins);
  }

  /// Create an instance of [UhxxGateway] that can perform requests to the HTTP API, connects
  /// to the gateway and is authenticated with a bot token.
  static Future<UhxxGateway> connectGateway(
          String token, Flags<GatewayIntents> intents,
          {GatewayClientOptions options = const GatewayClientOptions()}) =>
      connectGatewayWithOptions(
          GatewayApiOptions(token: token, intents: intents), options);

  /// Create an instance of [UhxxGateway] using the provided options.
  static Future<UhxxGateway> connectGatewayWithOptions(
    GatewayApiOptions apiOptions, [
    GatewayClientOptions clientOptions = const GatewayClientOptions(),
  ]) async {
    return _pluginConnect(apiOptions, clientOptions, () async {
      clientOptions.logger
        ..info('Connecting to the Gateway API')
        ..fine(
          'Token: ${apiOptions.token}, Authorization: ${apiOptions.authorizationHeader}, User-Agent: ${apiOptions.userAgent},'
          ' Intents: ${apiOptions.intents.value}, Payloads: ${apiOptions.payloadFormat.value}, Compression: ${apiOptions.compression.name},'
          ' Shards: ${apiOptions.shards?.join(', ')}, Total shards: ${apiOptions.totalShards}, Large threshold: ${apiOptions.largeThreshold}',
        )
        ..fine(
            'Plugins: ${clientOptions.plugins.map((plugin) => plugin.name).join(', ')}');

      final client = UhxxGateway._(apiOptions, clientOptions);

      client
        .._application = await client.applications.fetchCurrentApplication()
        .._user = await client.users.fetchCurrentUser();

      // We can't use client.gateway as it is not initialized yet
      final gatewayManager = GatewayManager(client);

      final gatewayBot = await gatewayManager.fetchGatewayBot();
      client.gateway = await Gateway.connect(client, gatewayBot);

      client.httpHandler.done.then((_) {
        if (client._doneCompleter.isCompleted) return;

        client._doneCompleter.completeError(
            UhxxException('HTTP handler was closed'), StackTrace.current);
        client.close();
      }, onError: (e, s) {
        if (client._doneCompleter.isCompleted) return;

        client._doneCompleter.completeError(e, s);
        client.close();
      });

      client.gateway.done.then((_) {
        if (client._doneCompleter.isCompleted) return;

        client._doneCompleter.completeError(
            UhxxException('Gateway was closed'), StackTrace.current);
        client.close();
      }, onError: (e, s) {
        if (client._doneCompleter.isCompleted) return;

        client._doneCompleter.completeError(e, s);
        client.close();
      });

      return client;
    }, clientOptions.plugins);
  }

  /// A future that completes when this client closes.
  ///
  /// If this client closes because of an error, this future will complete with that error.
  Future<void> get done => _doneCompleter.future;

  /// Close this client and any underlying resources.
  ///
  /// The client should not be used after this is called and unexpected behavior may occur.
  ///
  /// Returns the same future as [done].
  Future<void> close() {
    logger.info('Closing client');

    if (!_isClosed) {
      _isClosed = true;
      final closeFuture = _pluginClose(this, _doClose, options.plugins);

      if (!_doneCompleter.isCompleted) {
        _doneCompleter.complete(closeFuture);
      } else {
        closeFuture.ignore();
      }
    }

    assert(_doneCompleter.isCompleted);
    return _doneCompleter.future;
  }

  Future<void> _doClose();
}

/// A client that can make requests to the HTTP API and is authenticated with a bot token.
///
/// {@category core}
class UhxxRest extends Uhxx with ManagerMixin {
  @override
  final RestApiOptions apiOptions;

  @override
  final RestClientOptions options;

  @override
  late final HttpHandler httpHandler = HttpHandler(this);

  /// The application associated with this client.
  PartialApplication get application => _application;
  late final PartialApplication _application;

  /// The user associated with this client.
  PartialUser get user => _user;
  late final PartialUser _user;

  UhxxRest._(this.apiOptions, this.options);

  /// Add the current user to the thread with the ID [id].
  ///
  /// External references:
  /// * [ChannelManager.joinThread]
  /// * Discord API Reference: https://discord.com/developers/docs/resources/channel#join-thread
  Future<void> joinThread(Snowflake id) => channels.joinThread(id);

  /// Remove the current user from the thread with the ID [id].
  ///
  /// External references:
  /// * [ChannelManager.leaveThread]
  /// * Discord API Reference: https://discord.com/developers/docs/resources/channel#leave-thread
  Future<void> leaveThread(Snowflake id) => channels.leaveThread(id);

  /// List the guilds the current user is a member of.
  Future<List<UserGuild>> listGuilds(
          {Snowflake? before, Snowflake? after, int? limit}) =>
      users.listCurrentUserGuilds(before: before, after: after, limit: limit);

  @override
  Future<void> _doClose() => httpHandler.close();
}

/// {@category core}
class UhxxOAuth2 extends Uhxx with ManagerMixin implements UhxxRest {
  @override
  final OAuth2ApiOptions apiOptions;

  @override
  final RestClientOptions options;

  @override
  late final HttpHandler httpHandler = Oauth2HttpHandler(this);

  @override
  PartialApplication get application => _application;

  @override
  late final PartialApplication _application;

  @override
  PartialUser get user => _user;

  @override
  late final PartialUser _user;

  UhxxOAuth2._(this.apiOptions, this.options);

  @override
  Future<void> joinThread(Snowflake id) => channels.joinThread(id);

  @override
  Future<void> leaveThread(Snowflake id) => channels.leaveThread(id);

  @override
  Future<List<UserGuild>> listGuilds(
          {Snowflake? before, Snowflake? after, int? limit}) =>
      users.listCurrentUserGuilds(before: before, after: after, limit: limit);

  @override
  Future<void> _doClose() => httpHandler.close();
}

/// A client that can make requests to the HTTP API, connects to the Gateway and is authenticated with a bot token.
///
/// {@category core}
class UhxxGateway extends Uhxx
    with ManagerMixin, EventMixin
    implements UhxxRest {
  @override
  final GatewayApiOptions apiOptions;

  @override
  final GatewayClientOptions options;

  @override
  late final HttpHandler httpHandler = HttpHandler(this);

  @override
  PartialApplication get application => _application;

  @override
  late final PartialApplication _application;

  @override
  PartialUser get user => _user;

  @override
  late final PartialUser _user;

  /// The [Gateway] used by this client to send and receive Gateway events.
  // Initialized in connectGateway due to a circular dependency
  @override
  late final Gateway gateway;

  UhxxGateway._(this.apiOptions, this.options);

  @override
  Future<void> joinThread(Snowflake id) => channels.joinThread(id);

  @override
  Future<void> leaveThread(Snowflake id) => channels.leaveThread(id);

  @override
  Future<List<UserGuild>> listGuilds(
          {Snowflake? before, Snowflake? after, int? limit}) =>
      users.listCurrentUserGuilds(before: before, after: after, limit: limit);

  /// Update the client's voice state in the guild with the ID [guildId].
  void updateVoiceState(Snowflake guildId, GatewayVoiceStateBuilder builder) =>
      gateway.updateVoiceState(guildId, builder);

  /// Update the client's presence on all shards.
  void updatePresence(PresenceBuilder builder) =>
      gateway.updatePresence(builder);

  @override
  Future<void> _doClose() async {
    await [
      gateway.close(),
      httpHandler.close(),
    ].wait;
  }
}
