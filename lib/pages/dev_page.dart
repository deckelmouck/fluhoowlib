import 'package:flutter/material.dart';
import 'package:hoowlib/providers/books_provider.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import '../db/database_helper.dart';
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
    //final loc = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(
            bottom: Radius.circular(10),
          ),
          child: AppBar(
            title: Text(
              'dev tool',
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
                child: _loadingDbInfo
                    ? Row(children: const [CircularProgressIndicator(), SizedBox(width: 12), Text('Loading database info...')])
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Database Name: ${_dbName ?? "Unknown"}', style: const TextStyle(fontWeight: FontWeight.bold)),
                          Text('Database Size: ${_dbSize != null ? (_dbSize! / 1024).toStringAsFixed(2) + " KB" : "Unknown"}'),
                        ],
                      ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _showRaw = !_showRaw;
                });
              },
              child: Text(_showRaw ? 'Hide Raw Data' : 'Show Raw Data'),
            ),
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
