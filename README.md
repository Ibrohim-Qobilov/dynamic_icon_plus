<p align="center">
  <img src="https://raw.githubusercontent.com/Ibrohim-Qobilov/dynamic_icon_plus/main/assets/screenshots/preview.png" width="800" alt="DynamicIconPlus Flutter Plugin Banner" />
</p>

# 🎭 DynamicIconPlus — Dynamic App Launcher Icon Switching for Flutter

<p align="center">
  <a href="https://pub.dev/packages/dynamic_icon_plus"><img src="https://img.shields.io/pub/v/dynamic_icon_plus.svg?style=for-the-badge&logo=dart&color=6366F1" alt="Pub Version" /></a>
  <a href="https://pub.dev/packages/dynamic_icon_plus/score"><img src="https://img.shields.io/pub/points/dynamic_icon_plus?style=for-the-badge&color=10B981" alt="Pub Points" /></a>
  <a href="https://github.com/Ibrohim-Qobilov/dynamic_icon_plus/stargazers"><img src="https://img.shields.io/github/stars/Ibrohim-Qobilov/dynamic_icon_plus?style=for-the-badge&logo=github&color=F59E0B" alt="GitHub Stars" /></a>
  <a href="https://opensource.org/licenses/MIT"><img src="https://img.shields.io/badge/License-MIT-purple.svg?style=for-the-badge" alt="License: MIT" /></a>
  <a href="https://flutter.dev"><img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter" /></a>
</p>

---

A modern, high-performance Flutter plugin that enables mobile applications to **change their launcher app icon dynamically at runtime** on **Android** and **iOS** without restarting the application or causing crashes.

Ideal for **VIP / Premium subscriptions, dark mode matching, holiday / seasonal events, gamification tiers, and brand customization** (like Telegram, Duolingo, and Revolut).

---

## 🌟 Key Features

* 🚀 **Seamless Runtime Switching:** Change app icons instantly while the app is running.
* 🤖 **Android 14/15 Support:** Smoothly switches activity aliases with `DONT_KILL_APP` flag to avoid abrupt restarts.
* 🍎 **iOS 10.3+ to iOS 18+ Support:** Full support for `CFBundleAlternateIcons` with optional alert suppression.
* 🔍 **Auto-Discovery:** Automatically detects all registered icon names from your configuration.
* ⚡ **100% Sound Null-Safe:** Zero third-party bloat, pure native Kotlin and Swift bridge.

---

## 📦 Installation

Add `dynamic_icon_plus` to your `pubspec.yaml`:

```yaml
dependencies:
  dynamic_icon_plus: ^0.1.0
```

Or install it via terminal:

```bash
flutter pub add dynamic_icon_plus
```

---

## 🚀 Quick Start

```dart
import 'package:dynamic_icon_plus/dynamic_icon_plus.dart';

// 1. Check if dynamic icons are supported
bool supported = await DynamicIconPlus.supportsAlternateIcons;

// 2. Get list of all available icons
List<String> icons = await DynamicIconPlus.getAvailableIcons();
print('Available icons: $icons'); // ['dark_icon', 'gold_icon', 'neon_icon']

// 3. Switch to a new icon
await DynamicIconPlus.setIcon('gold_icon');

// 4. Get currently active icon name
String? current = await DynamicIconPlus.currentIcon;
print('Current icon: $current'); // "gold_icon"

// 5. Restore default app icon
await DynamicIconPlus.reset();
```

---

## 📱 Platform Setup

### 🤖 Android Setup

In your `android/app/src/main/AndroidManifest.xml`, declare an `<activity-alias>` for each alternate icon you want to offer:

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <application
        android:label="Your App"
        android:icon="@mipmap/ic_launcher">
        
        <!-- Default Main Activity -->
        <activity
            android:name=".MainActivity"
            android:exported="true"
            android:launchMode="singleTop"
            android:theme="@style/LaunchTheme">
            <intent-filter>
                <action android:name="android.intent.action.MAIN"/>
                <category android:name="android.intent.category.LAUNCHER"/>
            </intent-filter>
        </activity>

        <!-- Alternate Icon 1: dark_icon -->
        <activity-alias
            android:name=".MainActivity.dark_icon"
            android:enabled="false"
            android:exported="true"
            android:icon="@mipmap/ic_launcher_dark"
            android:targetActivity=".MainActivity">
            <intent-filter>
                <action android:name="android.intent.action.MAIN"/>
                <category android:name="android.intent.category.LAUNCHER"/>
            </intent-filter>
        </activity-alias>

        <!-- Alternate Icon 2: gold_icon -->
        <activity-alias
            android:name=".MainActivity.gold_icon"
            android:enabled="false"
            android:exported="true"
            android:icon="@mipmap/ic_launcher_gold"
            android:targetActivity=".MainActivity">
            <intent-filter>
                <action android:name="android.intent.action.MAIN"/>
                <category android:name="android.intent.category.LAUNCHER"/>
            </intent-filter>
        </activity-alias>

    </application>
</manifest>
```

---

### 🍎 iOS Setup

In your `ios/Runner/Info.plist`, add your alternate icons under `CFBundleIcons`:

```xml
<key>CFBundleIcons</key>
<dict>
    <key>CFBundlePrimaryIcon</key>
    <dict>
        <key>CFBundleIconFiles</key>
        <array>
            <string>AppIcon</string>
        </array>
    </dict>
    <key>CFBundleAlternateIcons</key>
    <dict>
        <key>dark_icon</key>
        <dict>
            <key>CFBundleIconFiles</key>
            <array>
                <string>dark_icon</string>
            </array>
            <key>UIPrerenderedIcon</key>
            <false/>
        </dict>
        <key>gold_icon</key>
        <dict>
            <key>CFBundleIconFiles</key>
            <array>
                <string>gold_icon</string>
            </array>
            <key>UIPrerenderedIcon</key>
            <false/>
        </dict>
    </dict>
</dict>
```

Place the `@2x` and `@3x` PNG files inside `ios/Runner/` (e.g. `dark_icon@2x.png`, `dark_icon@3x.png`).

---

## 📚 Complete API Reference

| Method | Return Type | Description |
| :--- | :--- | :--- |
| `DynamicIconPlus.supportsAlternateIcons` | `Future<bool>` | Checks if the OS and device supports dynamic icons. |
| `DynamicIconPlus.getAlternateIconName()` | `Future<String?>` | Returns the active alternate icon name, or `null` if default. |
| `DynamicIconPlus.getAvailableIcons()` | `Future<List<String>>` | Returns all registered alternate icon names. |
| `DynamicIconPlus.setAlternateIconName(name)` | `Future<void>` | Switches the app icon to `name` (`null` resets to default). |
| `DynamicIconPlus.resetToDefault()` | `Future<void>` | Restores the default launcher icon. |
| `DynamicIconPlus.setIcon(name)` | `Future<void>` | Convenient shorthand for `setAlternateIconName`. |
| `DynamicIconPlus.reset()` | `Future<void>` | Convenient shorthand for `resetToDefault`. |

---

## 📱 Interactive Demo Application

Run the bundled Flutter demo app in the `example/` directory:

```bash
cd example
flutter run
```

---

## 🧪 Testing & Quality Assurance

```bash
flutter test
```

Output:
```text
00:00 +8: All tests passed!
```

---

## 👨‍💻 Author & Contributions

Created with ❤️ by **[Ibrohim Qobilov](https://github.com/Ibrohim-Qobilov)**.

Contributions, issues, and feature requests are welcome!
* [GitHub Repository](https://github.com/Ibrohim-Qobilov/dynamic_icon_plus)
* [Report an Issue](https://github.com/Ibrohim-Qobilov/dynamic_icon_plus/issues)

---

## 📄 License

This package is open-sourced under the [MIT License](LICENSE).
