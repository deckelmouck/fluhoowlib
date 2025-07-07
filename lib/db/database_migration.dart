import 'package:sqflite/sqflite.dart';

Future<void> migrateDatabase(Database db, int oldVersion, int newVersion) async {
  if (oldVersion < 3) {
    // Migration for books table: rename columns gelesen -> readed, bewertung -> rating
    await db.execute('''
      ALTER TABLE books RENAME TO books_old;
    ''');
    await db.execute('''
      CREATE TABLE books(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        author TEXT,
        readed INTEGER,
        rating INTEGER
      );
    ''');
    await db.execute('''
      INSERT INTO books (id, title, author, readed, rating)
      SELECT id, title, author, gelesen, bewertung FROM books_old;
    ''');
    await db.execute('''
      DROP TABLE books_old;
    ''');

    // Migration for gelesen_tage table (if needed)
    await db.execute('''
      CREATE TABLE IF NOT EXISTS gelesen_tage(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT UNIQUE
      );
    ''');
  }
  // Add future migrations here
}
