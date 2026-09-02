import 'dynamic_icon_plus_platform_interface.dart';

/// A modern Flutter plugin for dynamically changing app launcher icons at runtime on Android and iOS.
class DynamicIconPlus {
  DynamicIconPlus._();

  /// Checks if the current operating system and platform supports dynamic icon switching.
  ///
  /// * **iOS:** Returns `true` on iOS 10.3 and later.
  /// * **Android:** Always returns `true`.
  static Future<bool> get supportsAlternateIcons {
    return DynamicIconPlusPlatform.instance.supportsAlternateIcons;
  }

  /// Gets the name of the currently active alternate icon.
  ///
  /// Returns `null` if the app is currently using the default launcher icon.
  static Future<String?> getAlternateIconName() {
    return DynamicIconPlusPlatform.instance.getAlternateIconName();
  }

  /// Gets the list of all registered alternate icon names available in the app.
  ///
  /// * **iOS:** Discovered from `CFBundleIcons -> CFBundleAlternateIcons` in `Info.plist`.
  /// * **Android:** Discovered from `<activity-alias>` entries in `AndroidManifest.xml`.
  static Future<List<String>> getAvailableIcons() {
    return DynamicIconPlusPlatform.instance.getAvailableIcons();
  }

  /// Changes the app icon to [iconName].
  ///
  /// If [iconName] is `null` or empty, restores the default icon.
  ///
  /// * [showAlert] (iOS only): Whether to show the native system dialog ("You have changed the icon for..."). Defaults to `true`.
  static Future<void> setAlternateIconName(
    String? iconName, {
    bool showAlert = true,
  }) {
    return DynamicIconPlusPlatform.instance.setAlternateIconName(
      iconName,
      showAlert: showAlert,
    );
  }

  /// Restores the app's default launcher icon.
  static Future<void> resetToDefault({bool showAlert = true}) {
    return DynamicIconPlusPlatform.instance.resetToDefault(showAlert: showAlert);
  }

  // --- Short-hand convenient aliases ---

  /// Convenient alias for [supportsAlternateIcons].
  static Future<bool> get isSupported => supportsAlternateIcons;

  /// Convenient alias for [getAlternateIconName].
  static Future<String?> get currentIcon => getAlternateIconName();

  /// Convenient alias for [setAlternateIconName].
  static Future<void> setIcon(String? name, {bool showAlert = true}) =>
      setAlternateIconName(name, showAlert: showAlert);

  /// Convenient alias for [resetToDefault].
  static Future<void> reset({bool showAlert = true}) =>
      resetToDefault(showAlert: showAlert);
}
