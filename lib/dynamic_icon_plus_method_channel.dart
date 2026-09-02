import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'dynamic_icon_plus_platform_interface.dart';

/// An implementation of [DynamicIconPlusPlatform] that uses method channels.
class MethodChannelDynamicIconPlus extends DynamicIconPlusPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('dynamic_icon_plus');

  @override
  Future<bool> get supportsAlternateIcons async {
    final supported = await methodChannel.invokeMethod<bool>('supportsAlternateIcons');
    return supported ?? false;
  }

  @override
  Future<String?> getAlternateIconName() async {
    final iconName = await methodChannel.invokeMethod<String?>('getAlternateIconName');
    return iconName;
  }

  @override
  Future<List<String>> getAvailableIcons() async {
    final icons = await methodChannel.invokeListMethod<String>('getAvailableIcons');
    return icons ?? <String>[];
  }

  @override
  Future<void> setAlternateIconName(
    String? iconName, {
    bool showAlert = true,
  }) async {
    await methodChannel.invokeMethod<void>('setAlternateIconName', <String, dynamic>{
      'iconName': iconName,
      'showAlert': showAlert,
    });
  }

  @override
  Future<void> resetToDefault({bool showAlert = true}) async {
    await methodChannel.invokeMethod<void>('resetToDefault', <String, dynamic>{
      'showAlert': showAlert,
    });
  }
}
