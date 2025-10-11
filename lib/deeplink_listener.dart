import 'package:flutter/services.dart';

class DeeplinkListener {
  static const MethodChannel _channel = MethodChannel('deeplink_listener');

  static const EventChannel _eventChannel = EventChannel(
    'deeplink_listener/events',
  );

  static Stream<String>? _linkStream;

  /// Get the initial link if app was launched from one
  static Future<String?> getInitialLink() async {
    final link = await _channel.invokeMethod<String>('getInitialLink');
    return link;
  }

  /// Listen for links while the app is running
  static Stream<String> get linkStream {
    _linkStream ??= _eventChannel.receiveBroadcastStream().map(
      (event) => event as String,
    );
    return _linkStream!;
  }
}
