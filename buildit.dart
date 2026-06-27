import 'dart:io';
import 'package:yaml/yaml.dart';
import 'package:path/path.dart' as path;

// Hauptfunktion
Future<void> main(List<String> arguments) async {
  print('Flutter Build Script mit Versionsabfrage');
  print('----------------------------------------');

  // 1. Aktuelle Version aus pubspec.yaml auslesen
  final pubspecPath = path.join(Directory.current.path, 'pubspec.yaml');
  final pubspecFile = File(pubspecPath);

  if (!await pubspecFile.exists()) {
    print('Fehler: pubspec.yaml nicht gefunden!');
    exit(1);
  }

  final pubspecContent = await pubspecFile.readAsString();
  final pubspecYaml = loadYaml(pubspecContent) as YamlMap;
  final currentVersion = pubspecYaml['version'] as String? ?? '1.0.0';

  // Extrahiere nur den major.minor.patch-Teil (ignoriere +buildNumber)
  final versionParts = currentVersion.split('+');
  final semanticVersion = versionParts[0];
  final buildNumber = versionParts.length > 1 ? versionParts[1] : null;

  print('Aktuelle Version: $currentVersion');
  print('Semantische Version: $semanticVersion');

  // 2. Version erhöhen?
  final shouldIncreaseVersion = _askYesNoQuestion('Möchtest du die Version erhöhen? (y/n)');

  String newSemanticVersion = semanticVersion;
  String? newBuildNumber = buildNumber;

  if (shouldIncreaseVersion) {
    newSemanticVersion = _askVersionIncrease(semanticVersion);
    final shouldIncreaseBuildNumber = _askYesNoQuestion('Möchtest du die Build-Number erhöhen? (y/n)');
    if (shouldIncreaseBuildNumber) {
      newBuildNumber = _increaseBuildNumber(buildNumber);
    }
    await _updateVersionInPubspec(pubspecPath, pubspecContent, newSemanticVersion, newBuildNumber);
  }

  // 3. Build für iOS und Android ausführen
  print('\nStarte Build für Version: ${newSemanticVersion}${newBuildNumber != null ? '+$newBuildNumber' : ''}');
  print('----------------------------------------');

  final buildIos = _askYesNoQuestion('Soll ein iOS-Build erstellt werden? (y/n)');
  final buildAndroid = _askYesNoQuestion('Soll ein Android-Build erstellt werden? (y/n)');

  if (buildIos) {
    print('\nStarte iOS-Build...');
    await Process.run('flutter', ['build', 'ios', '--release']);
  }

  if (buildAndroid) {
    print('\nStarte Android-Build...');
    await Process.run('flutter', ['build', 'apk', '--release']);
    // Alternativ für AppBundle:
    // await Process.run('flutter', ['build', 'appbundle', '--release']);
  }

  print('\nBuild abgeschlossen!');
}

// Hilfsfunktion: Ja/Nein-Frage
bool _askYesNoQuestion(String question) {
  while (true) {
    stdout.write('$question ');
    final answer = stdin.readLineSync()?.toLowerCase().trim();
    if (answer == 'y' || answer == 'yes') return true;
    if (answer == 'n' || answer == 'no') return false;
    print('Bitte antworte mit y (ja) oder n (nein).');
  }
}

// Hilfsfunktion: Version erhöhen
String _askVersionIncrease(String currentVersion) {
  final parts = currentVersion.split('.');
  if (parts.length != 3) {
    print('Ungültiges Versionsformat. Verwende Standard: 1.0.0');
    return '1.0.0';
  }

  final major = int.parse(parts[0]);
  final minor = int.parse(parts[1]);
  final patch = int.parse(parts[2]);

  print('\nWähle die Art der Versionserhöhung:');
  print('1. Major (z.B. 0.15.0 -> 1.0.0)');
  print('2. Minor (z.B. 0.15.0 -> 0.16.0)');
  print('3. Patch (z.B. 0.15.0 -> 0.15.1)');
  print('4. Benutzerdefiniert');

  stdout.write('Deine Wahl (1-4): ');
  final choice = stdin.readLineSync()?.trim();

  switch (choice) {
    case '1':
      return '${major + 1}.0.0';
    case '2':
      return '$major.${minor + 1}.0';
    case '3':
      return '$major.$minor.${patch + 1}';
    case '4':
      stdout.write('Gib die neue Version ein (z.B. 0.16.0): ');
      return stdin.readLineSync()?.trim() ?? currentVersion;
    default:
      print('Ungültige Auswahl. Version bleibt unverändert.');
      return currentVersion;
  }
}

// Hilfsfunktion: Build-Number erhöhen
String? _increaseBuildNumber(String? buildNumber) {
  if (buildNumber == null) return null;
  try {
    final currentBuild = int.parse(buildNumber);
    return (currentBuild + 1).toString();
  } catch (e) {
    print('Ungültige Build-Number. Setze auf 1 zurück.');
    return '1';
  }
}

// Hilfsfunktion: Version in pubspec.yaml aktualisieren
Future<void> _updateVersionInPubspec(
    String pubspecPath, String pubspecContent, String newSemanticVersion, String? newBuildNumber) async {
  final newVersion = newBuildNumber != null ? '$newSemanticVersion+$newBuildNumber' : newSemanticVersion;
  final updatedContent = pubspecContent.replaceFirst(
    RegExp(r'version:\s*[\d+\.]+'),
    'version: $newVersion',
  );

  await File(pubspecPath).writeAsString(updatedContent);
  print('Version in pubspec.yaml auf $newVersion aktualisiert.');
}