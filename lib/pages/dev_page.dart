import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hoowlib/l10n/app_localizations.dart';
import 'package:hoowlib/providers/books_provider.dart';
import 'package:provider/provider.dart';
import '../db/database_helper.dart';
import '../models/book.dart';
import '../widgets/books_stats.dart';
import 'dart:io';

//import 'package:hoowlib/l10n/app_localizations.dart';

class DevPage extends StatefulWidget {
  const DevPage({super.key});

  @override
  State<DevPage> createState() => _DevPageState();
}

class _DevPageState extends State<DevPage> {
  bool _showRaw = false;
  String? _dbName;
  int? _dbSize;
  bool _loadingDbInfo = true;

  Future<void> _insertMockBooks(BuildContext context) async {
    final booksProvider = context.read<BooksProvider>();
    for (int i = 0; i < 50; i++) {
      final book = Book(
        title: 'Mock Book #${i + 1}',
        author: 'Author ${String.fromCharCode(65 + (i % 26))}',
        readed: i % 2 == 0,
        rating: (i % 6),
        publicationDate: DateTime(2000 + (i % 25), 1 + (i % 12), 1 + (i % 28)),
        finishedDate: i % 2 == 0 ? DateTime.now().subtract(Duration(days: i)) : null,
      );
      await booksProvider.addBook(book);
    }
    // Capture the context you want to use
    final scaffoldContext = context;
    if (!mounted || !scaffoldContext.mounted) return;

    // Use the guarded context
    ScaffoldMessenger.of(scaffoldContext).showSnackBar(
      const SnackBar(content: Text('Inserted 50 mock books!')),
    );
  }

  Future<void> _deleteMockBooks(BuildContext context) async {
    final booksProvider = context.read<BooksProvider>();
    final mockBooks = booksProvider.books.where((b) => b.title.startsWith('Mock Book #')).toList();
    for (final book in mockBooks) {
      if (book.id != null) {
        await booksProvider.deleteBook(book);
      }
    }
    // Capture the context you want to use
    final scaffoldContext = context;
    if (!mounted || !scaffoldContext.mounted) return;

    // Use the guarded context
    ScaffoldMessenger.of(scaffoldContext).showSnackBar(
      SnackBar(content: Text('Deleted ${mockBooks.length} mock books!')),
    );
  }

  @override
  void initState() {
    super.initState();
    _fetchDbInfo();
  }

  Future<void> _fetchDbInfo() async {
    // Get database path and size
    try {
      final db = await DatabaseHelper().database;
      final path = db.path;
      _dbName = path.split('/').last;
      final file = File(path);
      _dbSize = await file.length();
    } catch (e) {
      _dbName = 'Error';
      _dbSize = null;
    }
    setState(() {
      _loadingDbInfo = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final books = context.watch<BooksProvider>().books;
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(
            bottom: Radius.circular(10),
          ),
          child: AppBar(
            title: Text(
              loc.devTool,
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.redAccent,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            const SizedBox(height: 5),
            // Database Info Section
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: SizedBox(
                  width: double.infinity,
                  child: _loadingDbInfo
                    ? Row(children: const [CircularProgressIndicator(), SizedBox(width: 12), Text('Loading database info...')])
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(loc.databaseName((_dbName ?? "Unknown")), style: const TextStyle(fontWeight: FontWeight.bold)),
                          Text(loc.databaseSize(_dbSize != null ? "${(_dbSize! / 1024).toStringAsFixed(2)} KB" : "Unknown")),
                        ],
                      ),
                ),
              ),
            ),
            const SizedBox(height: 5),
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: SizedBox(
                  width: double.infinity,
                  child: BooksStats(books: books),
                ),
              ),
            ),
            const SizedBox(height: 5),
            ElevatedButton(
              onPressed: () async {
                await _insertMockBooks(context);
              },
              child: Text(loc.mockupDb),
            ),
            const SizedBox(height: 5),
            ElevatedButton(
              onPressed: () async {
                await _deleteMockBooks(context);
              },
              child: Text(loc.deleteAllMockBooks),
            ),
            const SizedBox(height: 5),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _showRaw = !_showRaw;
                });
              },
              child: Text(_showRaw ? loc.hideRawData : loc.showRawData),
            ),
            const SizedBox(height: 5),
            if (_showRaw)
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  width: double.infinity,
                  child: SingleChildScrollView(
                    child: SelectableText(
                      const JsonEncoder.withIndent('  ').convert(
                        books.map((b) => b.toJson()).toList(),
                      ),
                      style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
