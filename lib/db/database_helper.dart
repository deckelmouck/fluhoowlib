import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/book.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

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
      version: 2, // Incremented version for migration
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE books(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            author TEXT,
            gelesen INTEGER,
            bewertung INTEGER
          )
        ''');
        await db.execute('''
          CREATE TABLE gelesen_tage(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            date TEXT UNIQUE
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('''
            CREATE TABLE IF NOT EXISTS gelesen_tage(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              date TEXT UNIQUE
            )
          ''');
        }
        // Add future migrations here
      },
    );
  }

  Future<int> insertBook(Book book) async {
    final db = await database;
    return await db.insert('books', book.toMap());
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

  // --- Gelesen Tage Methods ---
  Future<int> insertGelesenTag(DateTime date) async {
    final db = await database;
    return await db.insert(
      'gelesen_tage',
      {'date': date.toIso8601String().substring(0, 10)},
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  Future<int> deleteGelesenTag(DateTime date) async {
    final db = await database;
    return await db.delete(
      'gelesen_tage',
      where: 'date = ?',
      whereArgs: [date.toIso8601String().substring(0, 10)],
    );
  }

  Future<Set<DateTime>> getGelesenTage() async {
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
}
