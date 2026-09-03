import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:yaml/yaml.dart';

void main(List<String> args) async {
  stdout.writeln('🎭 DynamicIconPlus Generator v0.1.0');
  stdout.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

  final currentDir = Directory.current;
  final pubspecFile = File('${currentDir.path}/pubspec.yaml');

  if (!pubspecFile.existsSync()) {
    stderr.writeln('❌ Error: pubspec.yaml not found in ${currentDir.path}');
    exit(1);
  }

  final pubspecContent = pubspecFile.readAsStringSync();
  final dynamic pubspecYaml = loadYaml(pubspecContent);

  Map<String, String> iconsToProcess = {};

  // Check config in pubspec.yaml
  if (pubspecYaml is Map && pubspecYaml.containsKey('dynamic_icon_plus')) {
    final dynamic config = pubspecYaml['dynamic_icon_plus'];
    if (config is Map && config.containsKey('icons')) {
      final dynamic icons = config['icons'];
      if (icons is Map) {
        icons.forEach((key, value) {
          iconsToProcess[key.toString()] = value.toString();
        });
      }
    } else if (config is Map && config.containsKey('icons_dir')) {
      final dirPath = config['icons_dir'].toString();
      iconsToProcess = _scanIconsDir(Directory('${currentDir.path}/$dirPath'));
    }
  }

  // Default fallback: Scan assets/icons or assets/dynamic_icons
  if (iconsToProcess.isEmpty) {
    final defaultDir = Directory('${currentDir.path}/assets/icons');
    if (defaultDir.existsSync()) {
      iconsToProcess = _scanIconsDir(defaultDir);
    } else {
      final altDir = Directory('${currentDir.path}/assets/dynamic_icons');
      if (altDir.existsSync()) {
        iconsToProcess = _scanIconsDir(altDir);
      }
    }
  }

  if (iconsToProcess.isEmpty) {
    stdout.writeln('ℹ️ No icons found in assets/icons/ or pubspec.yaml.');
    stdout.writeln('👉 Please place your PNG icons into "assets/icons/" and re-run:');
    stdout.writeln('   dart run dynamic_icon_plus:generate');
    exit(0);
  }

  stdout.writeln('📦 Found ${iconsToProcess.length} icon(s) to process:');
  iconsToProcess.forEach((name, path) {
    stdout.writeln('   • $name -> $path');
  });
  stdout.writeln('────────────────────────────────────────────');

  // Process Android assets
  final androidResDir = Directory('${currentDir.path}/android/app/src/main/res');
  if (androidResDir.existsSync()) {
    _generateAndroidAssets(currentDir, iconsToProcess);
    _updateAndroidManifest(currentDir, iconsToProcess.keys.toList());
  } else {
    stdout.writeln('⚠️ Android project folder not found, skipping Android.');
  }

  // Process iOS assets
  final iosRunnerDir = Directory('${currentDir.path}/ios/Runner');
  if (iosRunnerDir.existsSync()) {
    _generateIosAssets(currentDir, iconsToProcess);
    _updateIosInfoPlist(currentDir, iconsToProcess.keys.toList());
  } else {
    stdout.writeln('⚠️ iOS project folder not found, skipping iOS.');
  }

  stdout.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  stdout.writeln('🎉 Successfully generated all dynamic app launcher icons!');
  stdout.writeln('🚀 You can now switch icons at runtime with:');
  stdout.writeln('   DynamicIconPlus.setIcon("icon_name");');
}

Map<String, String> _scanIconsDir(Directory dir) {
  final Map<String, String> icons = {};
  if (!dir.existsSync()) return icons;

  for (final entity in dir.listSync()) {
    if (entity is File) {
      final ext = entity.path.split('.').last.toLowerCase();
      if (ext == 'png' || ext == 'jpg' || ext == 'jpeg') {
        final fileName = entity.uri.pathSegments.last;
        final iconName = fileName.substring(0, fileName.lastIndexOf('.')).replaceAll(RegExp(r'[^a-zA-Z0-9_]'), '_');
        icons[iconName] = entity.path;
      }
    }
  }
  return icons;
}

void _generateAndroidAssets(Directory currentDir, Map<String, String> icons) {
  final densities = {
    'mdpi': 48,
    'hdpi': 72,
    'xhdpi': 96,
    'xxhdpi': 144,
    'xxxhdpi': 192,
  };

  for (final entry in icons.entries) {
    final iconName = entry.key;
    final file = File(entry.value);
    final bytes = file.readAsBytesSync();
    final image = img.decodeImage(bytes);

    if (image == null) {
      stderr.writeln('❌ Failed to decode image: ${entry.value}');
      continue;
    }

    for (final d in densities.entries) {
      final outDir = Directory('${currentDir.path}/android/app/src/main/res/mipmap-${d.key}');
      if (!outDir.existsSync()) outDir.createSync(recursive: true);

      final resized = img.copyResize(image, width: d.value, height: d.value, interpolation: img.Interpolation.cubic);
      final outFile = File('${outDir.path}/ic_launcher_$iconName.png');
      outFile.writeAsBytesSync(img.encodePng(resized));
    }
  }
  stdout.writeln('✓ Generated Android mipmap icons (mdpi, hdpi, xhdpi, xxhdpi, xxxhdpi)');
}

void _generateIosAssets(Directory currentDir, Map<String, String> icons) {
  final iosDir = Directory('${currentDir.path}/ios/Runner');
  if (!iosDir.existsSync()) return;

  for (final entry in icons.entries) {
    final iconName = entry.key;
    final file = File(entry.value);
    final bytes = file.readAsBytesSync();
    final image = img.decodeImage(bytes);

    if (image == null) {
      stderr.writeln('❌ Failed to decode image: ${entry.value}');
      continue;
    }

    // @2x (120x120)
    final img2x = img.copyResize(image, width: 120, height: 120, interpolation: img.Interpolation.cubic);
    File('${iosDir.path}/$iconName@2x.png').writeAsBytesSync(img.encodePng(img2x));

    // @3x (180x180)
    final img3x = img.copyResize(image, width: 180, height: 180, interpolation: img.Interpolation.cubic);
    File('${iosDir.path}/$iconName@3x.png').writeAsBytesSync(img.encodePng(img3x));

    // 1024x1024
    final img1024 = img.copyResize(image, width: 1024, height: 1024, interpolation: img.Interpolation.cubic);
    File('${iosDir.path}/$iconName-1024.png').writeAsBytesSync(img.encodePng(img1024));
  }
  stdout.writeln('✓ Generated iOS Runner icon assets (@2x, @3x, 1024)');
}

void _updateAndroidManifest(Directory currentDir, List<String> iconNames) {
  final manifestFile = File('${currentDir.path}/android/app/src/main/AndroidManifest.xml');
  if (!manifestFile.existsSync()) return;

  var content = manifestFile.readAsStringSync();
  bool modified = false;

  for (final name in iconNames) {
    final aliasMarker = 'android:name=".MainActivity.$name"';
    if (!content.contains(aliasMarker)) {
      final aliasSnippet = '''
        <!-- Alternate Icon: $name -->
        <activity-alias
            android:name=".MainActivity.$name"
            android:enabled="false"
            android:exported="true"
            android:icon="@mipmap/ic_launcher_$name"
            android:targetActivity=".MainActivity">
            <intent-filter>
                <action android:name="android.intent.action.MAIN"/>
                <category android:name="android.intent.category.LAUNCHER"/>
            </intent-filter>
        </activity-alias>
''';
      final appCloseIndex = content.lastIndexOf('</application>');
      if (appCloseIndex != -1) {
        content = '${content.substring(0, appCloseIndex)}$aliasSnippet    ${content.substring(appCloseIndex)}';
        modified = true;
      }
    }
  }

  if (modified) {
    manifestFile.writeAsStringSync(content);
    stdout.writeln('✓ Updated AndroidManifest.xml with activity-aliases');
  } else {
    stdout.writeln('✓ AndroidManifest.xml already configured');
  }
}

void _updateIosInfoPlist(Directory currentDir, List<String> iconNames) {
  final plistFile = File('${currentDir.path}/ios/Runner/Info.plist');
  if (!plistFile.existsSync()) return;

  var content = plistFile.readAsStringSync();
  bool modified = false;

  // Check if CFBundleIcons exists
  if (!content.contains('<key>CFBundleIcons</key>')) {
    final dictCloseIndex = content.lastIndexOf('</dict>');
    if (dictCloseIndex != -1) {
      final bundleIconsSnippet = '''
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
${iconNames.map((name) => '''			<key>$name</key>
			<dict>
				<key>CFBundleIconFiles</key>
				<array>
					<string>$name</string>
				</array>
				<key>UIPrerenderedIcon</key>
				<false/>
			</dict>''').join('\n')}
		</dict>
	</dict>
''';
      content = '${content.substring(0, dictCloseIndex)}$bundleIconsSnippet${content.substring(dictCloseIndex)}';
      modified = true;
    }
  } else {
    // Add any missing alternate icon entries
    for (final name in iconNames) {
      if (!content.contains('<key>$name</key>')) {
        final alternateIconsIndex = content.indexOf('<key>CFBundleAlternateIcons</key>');
        if (alternateIconsIndex != -1) {
          final dictOpenIndex = content.indexOf('<dict>', alternateIconsIndex);
          if (dictOpenIndex != -1) {
            final insertIndex = dictOpenIndex + 6;
            final snippet = '''\n			<key>$name</key>
			<dict>
				<key>CFBundleIconFiles</key>
				<array>
					<string>$name</string>
				</array>
				<key>UIPrerenderedIcon</key>
				<false/>
			</dict>''';
            content = '${content.substring(0, insertIndex)}$snippet${content.substring(insertIndex)}';
            modified = true;
          }
        }
      }
    }
  }

  if (modified) {
    plistFile.writeAsStringSync(content);
    stdout.writeln('✓ Updated Info.plist with CFBundleAlternateIcons');
  } else {
    stdout.writeln('✓ Info.plist already configured');
  }
}
