import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'dynamic_icon_plus_method_channel.dart';

/// The interface that platform-specific implementations of [DynamicIconPlus] must extend.
abstract class DynamicIconPlusPlatform extends PlatformInterface {
  /// Constructs a [DynamicIconPlusPlatform].
  DynamicIconPlusPlatform() : super(token: _token);

  static final Object _token = Object();

  static DynamicIconPlusPlatform _instance = MethodChannelDynamicIconPlus();

  /// The default instance of [DynamicIconPlusPlatform] to use.
  static DynamicIconPlusPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [DynamicIconPlusPlatform] when
  /// they register themselves.
  static set instance(DynamicIconPlusPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// Checks if the current platform supports dynamic icon switching.
  Future<bool> get supportsAlternateIcons {
    throw UnimplementedError('supportsAlternateIcons has not been implemented.');
  }

  /// Gets the currently active alternate icon name, or `null` if the default icon is active.
  Future<String?> getAlternateIconName() {
    throw UnimplementedError('getAlternateIconName() has not been implemented.');
  }

  /// Gets all registered alternate icon names available in the app.
  Future<List<String>> getAvailableIcons() {
    throw UnimplementedError('getAvailableIcons() has not been implemented.');
  }

  /// Sets the app icon to [iconName], or restores default icon if [iconName] is `null` or empty.
  Future<void> setAlternateIconName(
    String? iconName, {
    bool showAlert = true,
  }) {
    throw UnimplementedError('setAlternateIconName() has not been implemented.');
  }

  /// Restores the default launcher icon.
  Future<void> resetToDefault({bool showAlert = true}) {
    throw UnimplementedError('resetToDefault() has not been implemented.');
  }
}
