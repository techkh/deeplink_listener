import 'package:flutter_test/flutter_test.dart';
import 'package:deeplink_listener/deeplink_listener.dart';
import 'package:deeplink_listener/deeplink_listener_platform_interface.dart';
import 'package:deeplink_listener/deeplink_listener_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockDeeplinkListenerPlatform
    with MockPlatformInterfaceMixin
    implements DeeplinkListenerPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final DeeplinkListenerPlatform initialPlatform =
      DeeplinkListenerPlatform.instance;

  test('$MethodChannelDeeplinkListener is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelDeeplinkListener>());
  });

  test('getPlatformVersion', () async {
    DeeplinkListener deeplinkListenerPlugin = DeeplinkListener();
    MockDeeplinkListenerPlatform fakePlatform = MockDeeplinkListenerPlatform();
    DeeplinkListenerPlatform.instance = fakePlatform;

    //expect(await deeplinkListenerPlugin.getPlatformVersion(), '42');
  });
}
