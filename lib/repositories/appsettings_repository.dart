import '../models/appsettings.dart';
import '../db/database_helper.dart';

class AppSettingsRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<AppSettings> loadSettings() async {
    return await _dbHelper.getAppSettings();
  }

  Future<void> saveSettings(AppSettings settings) async {
    await _dbHelper.insertOrUpdateAppSettings(settings);
  }
}
