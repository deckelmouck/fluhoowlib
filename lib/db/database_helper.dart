import 'dart:async';
import 'package:hoowlib/models/appsettings.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/book.dart';
import 'database_migration.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  // #region Database Initialization
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'hoowlib.db');
    return await openDatabase(
      path,
      version: 9, // Incremented version for migration
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE books(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            author TEXT,
            readed INTEGER,
            rating INTEGER,
            publicationDate TEXT,
            finishedDate TEXT,
            isbn TEXT
          )
        ''');
        await db.execute('''
          CREATE TABLE gelesen_tage(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            date TEXT UNIQUE
          )
        ''');
        await db.execute('''
          CREATE TABLE app_settings(
            id INTEGER PRIMARY KEY,
            username TEXT,
            bookCount INTEGER,
            devMode INTEGER,
            showDevSwitch INTEGER,
            darkMode INTEGER
          )
        ''');
        // Insert default settings
        await db.insert('app_settings', {
          'id': 1,
          'username': '',
          'bookCount': 0,
          'devMode': 0,
          'showDevSwitch': 0,
          'darkMode': 0
        });
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        await migrateDatabase(db, oldVersion, newVersion);
      },
    );
  }
    // #region AppSettings CRUD Methods
    Future<int> insertOrUpdateAppSettings(AppSettings settings) async {
      final db = await database;
      return await db.insert(
        'app_settings',
        settings.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    Future<AppSettings> getAppSettings() async {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query('app_settings', where: 'id = ?', whereArgs: [1]);
      if (maps.isNotEmpty) {
        return AppSettings.fromMap(maps.first);
      } else {
        // Return default if not found
        return AppSettings(
          id: 1,
          username: '',
          bookCount: 0,
          devMode: false,
          showDevSwitch: false,
          darkMode: false,
        );
      }
    }
    // #endregion
  // #endregion

  // #region Book CRUD Methods
  Future<int> insertBook(Book book) async {
    final db = await database;
    return await db.insert('books', book.toMap());
  }

  Future<Book?> getBookById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'books',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Book.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<List<Book>> getBooks() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('books');
    return List.generate(maps.length, (i) => Book.fromMap(maps[i]));
  }

  Future<void> deleteAllBooks() async {
    final db = await database;
    await db.delete('books');
  }

  Future<int> deleteBook(int id) async {
    final db = await database;
    return await db.delete(
      'books',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> updateBook(Book book) async {
    final db = await database;
    return await db.update(
      'books',
      book.toMap(),
      where: 'id = ?',
      whereArgs: [book.id],
    );
  }
  // #endregion

  // #region ReadedDay Methods
  Future<int> insertReadedDay(DateTime date) async {
    final db = await database;
    return await db.insert(
      'gelesen_tage',
      {'date': date.toIso8601String().substring(0, 10)},
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  Future<int> deleteReadedDay(DateTime date) async {
    final db = await database;
    return await db.delete(
      'gelesen_tage',
      where: 'date = ?',
      whereArgs: [date.toIso8601String().substring(0, 10)],
    );
  }

  Future<Set<DateTime>> getReadedDays() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('gelesen_tage');
    return maps.map((m) {
      final dateStr = m['date'] as String;
      final parts = dateStr.split('-');
      return DateTime(
        int.parse(parts[0]),
        int.parse(parts[1]),
        int.parse(parts[2]),
      );
    }).toSet();
  }
  // #endregion
}
