class AppSettings {
  int id;
  String username;
  int bookCount;
  bool devMode;
  bool showDevSwitch;
  bool darkMode;
  bool libraryGridView;
  String? languageCode;

  AppSettings({
    this.id = 1,
    required this.username,
    required this.bookCount,
    required this.devMode,
    required this.showDevSwitch,
    required this.darkMode,
    required this.libraryGridView,
    this.languageCode,
  });

  factory AppSettings.fromMap(Map<String, dynamic> map) {
    return AppSettings(
      id: map['id'] ?? 1,
      username: map['username'] ?? '',
      bookCount: map['bookCount'] ?? 0,
      devMode: (map['devMode'] ?? 0) == 1,
      showDevSwitch: (map['showDevSwitch'] ?? 0) == 1,
      darkMode: (map['darkMode'] ?? 0) == 1,
      libraryGridView: (map['libraryGridView'] ?? 0) == 1,
      languageCode: map['languageCode'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'bookCount': bookCount,
      'devMode': devMode ? 1 : 0,
      'showDevSwitch': showDevSwitch ? 1 : 0,
      'darkMode': darkMode ? 1 : 0,
      'libraryGridView': libraryGridView ? 1 : 0,
      'languageCode': languageCode,
    };
  }
}
