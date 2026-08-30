import 'package:flutter/widgets.dart';
import '../models/appsettings.dart';
import '../repositories/appsettings_repository.dart';

class AppsettingsProvider extends ChangeNotifier {
  final AppSettingsRepository _repository = AppSettingsRepository();
  String _username = "";
  int _bookCount = 0;
  bool _devMode = false;
  bool _showDevSwitch = false;
  bool _darkMode = false;
  bool _libraryGridView = false;
  String? _languageCode;
  bool _loaded = false;

  AppsettingsProvider() {
    loadSettings();
  }

  Future<void> loadSettings() async {
    final settings = await _repository.loadSettings();
    _username = settings.username;
    _bookCount = settings.bookCount;
    _devMode = settings.devMode;
    _showDevSwitch = settings.showDevSwitch;
    _darkMode = settings.darkMode;
    _libraryGridView = settings.libraryGridView;
    _languageCode = settings.languageCode;
    _loaded = true;
    notifyListeners();
  }

  Future<void> _saveSettings() async {
    if (!_loaded) return;
    final settings = AppSettings(
      id: 1,
      username: _username,
      bookCount: _bookCount,
      devMode: _devMode,
      showDevSwitch: _showDevSwitch,
      darkMode: _darkMode,
      libraryGridView: _libraryGridView,
      languageCode: _languageCode,
    );
    await _repository.saveSettings(settings);
  }

  String? get languageCode => _languageCode;
  void setLanguageCode(String? code) {
    _languageCode = code;
    notifyListeners();
    _saveSettings();
  }

  String get username => _username;

  void setUsername(String newUsername) {
    _username = newUsername;
    notifyListeners();
    _saveSettings();
  }

  int get bookCount => _bookCount;

  void setBookCount(int newBookCount) {
    _bookCount = newBookCount;
    notifyListeners();
    _saveSettings();
  }

  bool get devMode => _devMode;

  void setDevMode(bool newDevMode) {
    _devMode = newDevMode;
    notifyListeners();
    _saveSettings();
  }

  bool get showDevSwitch => _showDevSwitch;

  void setShowDevSwitch(bool showDevSwitch) {
    _showDevSwitch = showDevSwitch;
    notifyListeners();
    _saveSettings();
  }

  bool get isDarkMode => _darkMode;

  void setDarkMode(bool newMode) {
    _darkMode = newMode;
    notifyListeners();
    _saveSettings();
  }

  bool get libraryGridView => _libraryGridView;

  void setLibraryGridView(bool enabled) {
    _libraryGridView = enabled;
    notifyListeners();
    _saveSettings();
  }
}
