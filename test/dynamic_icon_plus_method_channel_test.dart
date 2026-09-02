import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dynamic_icon_plus/dynamic_icon_plus_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelDynamicIconPlus platform = MethodChannelDynamicIconPlus();
  const MethodChannel channel = MethodChannel('dynamic_icon_plus');

  String? mockIcon;

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
      switch (methodCall.method) {
        case 'supportsAlternateIcons':
          return true;
        case 'getAlternateIconName':
          return mockIcon;
        case 'getAvailableIcons':
          return <String>['dark_icon', 'gold_icon'];
        case 'setAlternateIconName':
          mockIcon = methodCall.arguments['iconName'] as String?;
          return null;
        case 'resetToDefault':
          mockIcon = null;
          return null;
        default:
          return null;
      }
    });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('supportsAlternateIcons returns mocked true', () async {
    expect(await platform.supportsAlternateIcons, true);
  });

  test('getAvailableIcons returns mocked list', () async {
    expect(await platform.getAvailableIcons(), ['dark_icon', 'gold_icon']);
  });

  test('setAlternateIconName sets and updates icon', () async {
    await platform.setAlternateIconName('gold_icon');
    expect(await platform.getAlternateIconName(), 'gold_icon');

    await platform.resetToDefault();
    expect(await platform.getAlternateIconName(), null);
  });
}
