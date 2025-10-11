import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'deeplink_listener_platform_interface.dart';

/// An implementation of [DeeplinkListenerPlatform] that uses method channels.
class MethodChannelDeeplinkListener extends DeeplinkListenerPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('deeplink_listener');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
