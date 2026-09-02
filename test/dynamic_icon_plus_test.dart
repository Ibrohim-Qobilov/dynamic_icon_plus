import 'package:flutter_test/flutter_test.dart';
import 'package:dynamic_icon_plus/dynamic_icon_plus.dart';
import 'package:dynamic_icon_plus/dynamic_icon_plus_platform_interface.dart';
import 'package:dynamic_icon_plus/dynamic_icon_plus_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockDynamicIconPlusPlatform
    with MockPlatformInterfaceMixin
    implements DynamicIconPlusPlatform {
  String? _currentIcon;

  @override
  Future<bool> get supportsAlternateIcons => Future.value(true);

  @override
  Future<String?> getAlternateIconName() => Future.value(_currentIcon);

  @override
  Future<List<String>> getAvailableIcons() =>
      Future.value(<String>['dark_theme', 'gold_vip', 'holiday']);

  @override
  Future<void> setAlternateIconName(String? iconName, {bool showAlert = true}) {
    _currentIcon = iconName;
    return Future.value();
  }

  @override
  Future<void> resetToDefault({bool showAlert = true}) {
    _currentIcon = null;
    return Future.value();
  }
}

void main() {
  final DynamicIconPlusPlatform initialPlatform = DynamicIconPlusPlatform.instance;

  test('$MethodChannelDynamicIconPlus is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelDynamicIconPlus>());
  });

  group('DynamicIconPlus High-Level API Tests', () {
    late MockDynamicIconPlusPlatform fakePlatform;

    setUp(() {
      fakePlatform = MockDynamicIconPlusPlatform();
      DynamicIconPlusPlatform.instance = fakePlatform;
    });

    test('supportsAlternateIcons returns true', () async {
      expect(await DynamicIconPlus.supportsAlternateIcons, true);
      expect(await DynamicIconPlus.isSupported, true);
    });

    test('getAvailableIcons returns list of icons', () async {
      final icons = await DynamicIconPlus.getAvailableIcons();
      expect(icons, ['dark_theme', 'gold_vip', 'holiday']);
    });

    test('setAlternateIconName and getAlternateIconName work correctly', () async {
      expect(await DynamicIconPlus.getAlternateIconName(), null);

      await DynamicIconPlus.setAlternateIconName('gold_vip');
      expect(await DynamicIconPlus.getAlternateIconName(), 'gold_vip');
      expect(await DynamicIconPlus.currentIcon, 'gold_vip');

      await DynamicIconPlus.resetToDefault();
      expect(await DynamicIconPlus.getAlternateIconName(), null);
    });

    test('Short-hand aliases work as expected', () async {
      await DynamicIconPlus.setIcon('dark_theme');
      expect(await DynamicIconPlus.currentIcon, 'dark_theme');

      await DynamicIconPlus.reset();
      expect(await DynamicIconPlus.currentIcon, null);
    });
  });
}
