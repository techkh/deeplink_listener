import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'deeplink_listener_method_channel.dart';

abstract class DeeplinkListenerPlatform extends PlatformInterface {
  /// Constructs a DeeplinkListenerPlatform.
  DeeplinkListenerPlatform() : super(token: _token);

  static final Object _token = Object();

  static DeeplinkListenerPlatform _instance = MethodChannelDeeplinkListener();

  /// The default instance of [DeeplinkListenerPlatform] to use.
  ///
  /// Defaults to [MethodChannelDeeplinkListener].
  static DeeplinkListenerPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [DeeplinkListenerPlatform] when
  /// they register themselves.
  static set instance(DeeplinkListenerPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
