# Changelog

All notable changes to the `dynamic_icon_plus` plugin will be documented in this file.

## 0.1.1

* Add built-in CLI generator (`dart run dynamic_icon_plus:generate`).
* Add Uzbek documentation (`README_UZ.md`), working badge links, and expandable quick guide.

## [0.1.0] - 2026-09-02

### Added
* 🚀 **Initial Release:**
  * Support for dynamic app launcher icon switching at runtime on iOS (iOS 10.3+) and Android.
  * `supportsAlternateIcons` / `isSupported`: Check platform support.
  * `getAlternateIconName` / `currentIcon`: Get currently active icon name.
  * `getAvailableIcons`: Automatically discover all configured alternate icon names from Android activity-aliases and iOS Plist.
  * `setAlternateIconName(name)` / `setIcon(name)`: Smoothly switch icon with `DONT_KILL_APP` flag on Android and optional alert suppression on iOS.
  * `resetToDefault` / `reset`: Restore default app launcher icon.
  * Comprehensive example application with interactive UI.
  * 100% test coverage with unit and method channel tests.
