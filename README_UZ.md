<p align="center">
  <img src="https://raw.githubusercontent.com/Ibrohim-Qobilov/dynamic_icon_plus/main/assets/screenshots/preview.png" width="800" alt="DynamicIconPlus Flutter Plugin Banner" />
</p>

<p align="center">
  <a href="README_UZ.md">🇺🇿 <b>O'zbekcha Hujjatlar</b></a> &nbsp;•&nbsp;
  <a href="README.md">🇬🇧 <b>English Documentation</b></a>
</p>

# 🎭 DynamicIconPlus — Flutter uchun Dinamik Ilova Belgisini Almashtirish

<p align="center">
  <a href="https://pub.dev/packages/dynamic_icon_plus"><img src="https://img.shields.io/pub/v/dynamic_icon_plus.svg?style=for-the-badge&logo=dart&color=6366F1" alt="Pub Version" /></a>
  <a href="https://pub.dev/packages/dynamic_icon_plus/score"><img src="https://img.shields.io/pub/points/dynamic_icon_plus?style=for-the-badge&color=10B981" alt="Pub Points" /></a>
  <a href="https://github.com/Ibrohim-Qobilov/dynamic_icon_plus/stargazers"><img src="https://img.shields.io/github/stars/Ibrohim-Qobilov/dynamic_icon_plus?style=for-the-badge&logo=github&color=F59E0B" alt="GitHub Stars" /></a>
  <a href="https://opensource.org/licenses/MIT"><img src="https://img.shields.io/badge/License-MIT-purple.svg?style=for-the-badge" alt="License: MIT" /></a>
  <a href="https://flutter.dev"><img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter" /></a>
</p>

---

<table align="center">
  <tr>
    <td align="center">
      <img src="https://raw.githubusercontent.com/Ibrohim-Qobilov/dynamic_icon_plus/main/assets/images/android.gif" alt="Android Demo" width="340" />
      <br />
      <strong>🤖 Android Jonli Namoyish</strong>
    </td>
    <td align="center">
      <img src="https://raw.githubusercontent.com/Ibrohim-Qobilov/dynamic_icon_plus/main/assets/images/ios.gif" alt="iOS Demo" width="340" />
      <br />
      <strong>🍎 iOS Jonli Namoyish</strong>
    </td>
  </tr>
</table>

---

**`dynamic_icon_plus`** — bu Flutter ilovalarida dastur ishlayotgan vaqtda (runtime) ilovani qayta ishga tushirmasdan yoki qotib qolmasdan **telefon Bosh ekranidagi ilova belgisini (app launcher icon) dinamik almashtirish** uchun yaratilgan zamonaviy va tezkor plagin.

Ushbu plagin **VIP / Premium obunalar, tungi rejimga moslashish, bayram / mavsumiy aksiyalar va brend kustomizatsiyasi** (Telegram, Duolingo, Revolut kabi) uchun ayni muddao!

---

## 🌟 Asosiy Imkoniyatlari

* 🚀 **Bir Zumda Almashtirish:** Dastur ochiq turganda ikonkani silliq va tez o'zgartirish.
* 🤖 **Android 14/15 Qo'llab-quvvatlash:** Ilova to'satdan yopilib ketmasligi uchun `DONT_KILL_APP` rejimidagi `activity-alias` tizimi.
* 🍎 **iOS 10.3+ dan iOS 18+ gacha:** Tizim bildirishnomasini yashirish imkoniyati bilan `CFBundleAlternateIcons` to'liq qo'llab-quvvatlanadi.
* 🔍 **Avtomatik Aniqlash:** Konfiguratsiyangizdagi barcha mavjud ikonkalarni avtomatik ro'yxat qilib beradi.
* ⚡ **100% Sound Null-Safe:** Hech qanday keraksiz bog'liqliklarsiz, toza Kotlin va Swift nativ ko'prigi.

---

## 📦 O'rnatish

Loyihangizdagi `pubspec.yaml` fayliga qo'shing:

```yaml
dependencies:
  dynamic_icon_plus: ^0.1.0
```

Yoki terminal orqali o'rnating:

```bash
flutter pub add dynamic_icon_plus
```

---

## ⚡ Avtomatik Ikonka Generatori (Qo'lda Ishlashga Hojat Yo'q! 🚀)

Android va iOS uchun rasmlar o'lchamini qo'lda o'zgartirish yoki `AndroidManifest.xml` / `Info.plist` ni qo'lda tahrirlash shart emas!

1. PNG rasmlaringizni `assets/icons/` papkasiga tashlang:
```text
my_flutter_app/
└── assets/
    └── icons/
        ├── dark_icon.png
        ├── gold_icon.png
        └── neon_icon.png
```

2. Terminalda bitta buyruq bering:
```bash
dart run dynamic_icon_plus:generate
```

Ushbu buyruq avtomatik tarzda:
* 🤖 Android uchun barcha 5 xil zichlikdagi (`mdpi`, `hdpi`, `xhdpi`, `xxhdpi`, `xxxhdpi`) aktivlarni `android/app/src/main/res/` ga joylaydi;
* 🍎 iOS uchun barcha `@2x`, `@3x` va `1024` rasmlarini `ios/Runner/` ga joylaydi;
* 📝 `AndroidManifest.xml` fayliga `<activity-alias>` larini avtomatik yozadi;
* 📝 `Info.plist` fayliga `CFBundleAlternateIcons` sozlamalarini ulaydi.

---

## 🚀 Tezkor Boshlash

```dart
import 'package:dynamic_icon_plus/dynamic_icon_plus.dart';

// 1. Qurilmada dinamik ikonka o'zgartirish mumkinligini tekshirish
bool supported = await DynamicIconPlus.supportsAlternateIcons;

// 2. Mavjud barcha ikonkalarni ro'yxat qilib olish
List<String> icons = await DynamicIconPlus.getAvailableIcons();
print('Mavjud ikonkalari: $icons'); // ['dark_icon', 'gold_icon', 'neon_icon']

// 3. Yangi ikonkaga o'tkazish
await DynamicIconPlus.setIcon('gold_icon');

// 4. Hozirgi aktiv ikonka nomini bilish
String? current = await DynamicIconPlus.currentIcon;
print('Hozirgi ikonka: $current');

// 5. Asl standart (Default) ikonkaga qaytarish
await DynamicIconPlus.reset();
```

---

## 📖 API Ma'lumotnomasi

| Metod / Xususiyat | Qaytarish Turi | Tavsifi |
| :--- | :--- | :--- |
| `supportsAlternateIcons` | `Future<bool>` | Qurilma dinamik ikonkalarni qo'llab-quvvatlashini tekshiradi |
| `getAlternateIconName()` | `Future<String?>` | Hozirgi aktiv muqobil ikonka nomini qaytaradi (`null` bo'lsa default) |
| `getAvailableIcons()` | `Future<List<String>>` | Konfiguratsiya qilingan barcha mavjud ikonka nomlarini oladi |
| `setAlternateIconName(name)` | `Future<void>` | Ikonkani belgilangan nomdagi ikonkaga o'zgartiradi |
| `resetToDefault()` | `Future<void>` | Ilova belgisini asl holiga qaytaradi |
| `setIcon(name)` | `Future<void>` | `setAlternateIconName` uchun qulay qisqartma |
| `reset()` | `Future<void>` | `resetToDefault` uchun qulay qisqartma |
| `currentIcon` | `Future<String?>` | `getAlternateIconName` uchun qulay getter |

---

## 📱 Amaliy Misol (VIP Obuna / Dark Mode)

```dart
ElevatedButton.icon(
  icon: const Icon(Icons.workspace_premium_rounded, color: Colors.amber),
  label: const Text('Gold VIP Ikonkaga O\'tish'),
  onPressed: () async {
    try {
      await DynamicIconPlus.setIcon('gold_icon');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ilova belgisi Gold VIP ga o\'zgartirildi!')),
      );
    } catch (e) {
      print('Xatolik: $e');
    }
  },
)
```

---

## 📄 Litsenziya

Ushbu loyiha [MIT Litsenziyasi](LICENSE) asosida erkin tarqatiladi.
Muallif: **Ibrohim Qobilov** ([@Ibrohim-Qobilov](https://github.com/Ibrohim-Qobilov))
