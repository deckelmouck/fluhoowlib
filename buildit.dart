/// # Flutter Build Script with Version Management
///
/// This Dart script automates the build process for Flutter apps (iOS & Android).
/// It reads the current version from `pubspec.yaml`, asks if you want to increment
/// the version (major, minor, patch, or custom), and then executes the desired builds.
///
/// ## Requirements
/// - Dart SDK (minimum 2.19.0)
/// - Flutter SDK
/// - `yaml` package as a dev dependency in `pubspec.yaml`:
///   ```yaml
///   dev_dependencies:
///     yaml: ^3.1.2
///   ```
///
/// ## Usage
/// 1. Save this script as `build_script.dart` in the root directory of your Flutter project.
/// 2. Run `dart pub get` to install dependencies.
/// 3. Start the script with:
///    ```bash
///    dart run build_script.dart
///    ```
///
/// ## Features
/// - Automatically detects the current version (including build number suffixes like `+33`)
/// - Interactive prompt to increment the version (major/minor/patch/custom)
/// - Optional build number increment
/// - Choose between iOS and Android builds
/// - Supports `flutter build ios` and `flutter build apk`
///
/// ## Example Workflow
/// ```
/// Flutter Build Script with Version Prompt
/// ----------------------------------------
/// Current Version: 0.15.0+33
/// Semantic Version: 0.15.0
/// Build Number: 33
///
/// Do you want to increment the version? (y/n) y
///
/// Choose the type of version increment:
/// 1. Major (e.g., 0.15.0 -> 1.0.0)
/// 2. Minor (e.g., 0.15.0 -> 0.16.0)
/// 3. Patch (e.g., 0.15.0 -> 0.15.1)
/// 4. Custom
/// Your choice (1-4): 2
/// Do you want to increment the build number? (y/n) y
/// Updated version in pubspec.yaml to 0.16.0+34.
///
/// Starting build for version: 0.16.0+34
/// ----------------------------------------
/// Should an iOS build be created? (y/n) y
/// Should an Android build be created? (y/n) n
///
/// Starting iOS build...
/// iOS build successful!
///
/// Build process completed!
/// ```

import 'dart:io';
import 'package:yaml/yaml.dart';
import 'package:path/path.dart' as path;

/// Main function: Starts the build process.
Future<void> main(List<String> arguments) async {
  print('Flutter Build Script with Version Prompt');
  print('----------------------------------------');

  // 1. Read the current version from pubspec.yaml
  final pubspecPath = path.join(Directory.current.path, 'pubspec.yaml');
  final pubspecFile = File(pubspecPath);

  if (!await pubspecFile.exists()) {
    print('Error: pubspec.yaml not found!');
    print('Make sure you are running the script from the root directory of your Flutter project.');
    exit(1);
  }

  final pubspecContent = await pubspecFile.readAsString();
  final pubspecYaml = loadYaml(pubspecContent) as YamlMap;
  final currentVersion = pubspecYaml['version'] as String? ?? '1.0.0';

  // Extract semantic version (major.minor.patch) and build number (if present)
  final versionParts = currentVersion.split('+');
  final semanticVersion = versionParts[0];
  final buildNumber = versionParts.length > 1 ? versionParts[1] : null;

  print('Current Version: $currentVersion');
  print('Semantic Version: $semanticVersion');
  if (buildNumber != null) {
    print('Build Number: $buildNumber');
  }

  // 2. Ask if the version should be incremented
  final shouldIncreaseVersion = _askYesNoQuestion('Do you want to increment the version? (y/n)');

  String newSemanticVersion = semanticVersion;
  String? newBuildNumber = buildNumber;

  if (shouldIncreaseVersion) {
    newSemanticVersion = _askVersionIncrease(semanticVersion);
    final shouldIncreaseBuildNumber = _askYesNoQuestion('Do you want to increment the build number? (y/n)');
    if (shouldIncreaseBuildNumber) {
      newBuildNumber = _increaseBuildNumber(buildNumber);
    }
    await _updateVersionInPubspec(pubspecPath, pubspecContent, newSemanticVersion, newBuildNumber);
  }

  // 3. Execute builds for iOS and Android
  final fullVersion = newBuildNumber != null ? '$newSemanticVersion+$newBuildNumber' : newSemanticVersion;
  print('\nStarting build for version: $fullVersion');
  print('----------------------------------------');

  final buildIos = _askYesNoQuestion('Should an iOS build be created? (y/n)');
  final buildAndroid = _askYesNoQuestion('Should an Android build be created? (y/n)');

  if (buildIos) {
    print('\nStarting iOS build...');
    final iosResult = await Process.run('flutter', ['build', 'ios', '--release']);
    if (iosResult.exitCode != 0) {
      print('Error during iOS build:');
      print(iosResult.stderr);
    } else {
      print('iOS build successful!');
    }
  }

  if (buildAndroid) {
    print('\nStarting Android build (APK)...');
    final androidResult = await Process.run('flutter', ['build', 'apk', '--release']);
    if (androidResult.exitCode != 0) {
      print('Error during Android build:');
      print(androidResult.stderr);
    } else {
      print('Android build successful!');
      print('APK can be found at: build/app/outputs/flutter-apk/app-release.apk');
    }
  }

  print('\nBuild process completed!');
}

/// Asks a yes/no question and returns the result as a `bool`.
///
/// Example:
/// ```dart
/// final answer = _askYesNoQuestion('Do you want to continue? (y/n)');
/// ```
bool _askYesNoQuestion(String question) {
  while (true) {
    stdout.write('$question ');
    final answer = stdin.readLineSync()?.toLowerCase().trim();
    if (answer == 'y' || answer == 'yes') return true;
    if (answer == 'n' || answer == 'no') return false;
    print('Please answer with y (yes) or n (no).');
  }
}

/// Asks for the type of version increment (major/minor/patch/custom).
///
/// - [currentVersion]: Current semantic version (e.g., `0.15.0`)
/// - Returns the new version as a `String`.
String _askVersionIncrease(String currentVersion) {
  final parts = currentVersion.split('.');
  if (parts.length != 3) {
    print('Invalid version format. Using default: 1.0.0');
    return '1.0.0';
  }

  final major = int.parse(parts[0]);
  final minor = int.parse(parts[1]);
  final patch = int.parse(parts[2]);

  print('\nChoose the type of version increment:');
  print('1. Major (e.g., $currentVersion -> ${major + 1}.0.0)');
  print('2. Minor (e.g., $currentVersion -> $major.${minor + 1}.0)');
  print('3. Patch (e.g., $currentVersion -> $major.$minor.${patch + 1})');
  print('4. Custom');

  stdout.write('Your choice (1-4): ');
  final choice = stdin.readLineSync()?.trim();

  switch (choice) {
    case '1':
      return '${major + 1}.0.0';
    case '2':
      return '$major.${minor + 1}.0';
    case '3':
      return '$major.$minor.${patch + 1}';
    case '4':
      stdout.write('Enter the new version (e.g., 0.16.0): ');
      return stdin.readLineSync()?.trim() ?? currentVersion;
    default:
      print('Invalid choice. Version remains unchanged.');
      return currentVersion;
  }
}

/// Increments the build number by 1 or resets it to 1 if invalid.
///
/// - [buildNumber]: Current build number (e.g., `33`)
/// - Returns the new build number as a `String` or `null` if none was present.
String? _increaseBuildNumber(String? buildNumber) {
  if (buildNumber == null) return null;
  try {
    final currentBuild = int.parse(buildNumber);
    return (currentBuild + 1).toString();
  } catch (e) {
    print('Invalid build number. Resetting to 1.');
    return '1';
  }
}

/// Updates the version in `pubspec.yaml`.
///
/// - [pubspecPath]: Path to `pubspec.yaml`
/// - [pubspecContent]: Current content of the file
/// - [newSemanticVersion]: New semantic version (e.g., `0.16.0`)
/// - [newBuildNumber]: New build number (e.g., `34`) or `null`
Future<void> _updateVersionInPubspec(
    String pubspecPath, String pubspecContent, String newSemanticVersion, String? newBuildNumber) async {
  final newVersion = newBuildNumber != null ? '$newSemanticVersion+$newBuildNumber' : newSemanticVersion;
  final updatedContent = pubspecContent.replaceFirst(
    RegExp(r'version:\s*[\d+\.]+'),
    'version: $newVersion',
  );

  await File(pubspecPath).writeAsString(updatedContent);
  print('Updated version in pubspec.yaml to $newVersion.');
}