import 'package:flutter/material.dart';
import 'package:hoowlib/l10n/app_localizations.dart';
import 'package:hoowlib/providers/books_provider.dart';
import 'package:provider/provider.dart';
import 'dart:convert';

class DevPage extends StatefulWidget {
  const DevPage({super.key});

  @override
  State<DevPage> createState() => _DevPageState();
}

class _DevPageState extends State<DevPage> {
  bool _showRaw = false;

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
              'dev tool',
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.blue,
          ),
        ),
      ),
      body: SafeArea(
        child:  Column(
          children: <Widget>[
            const SizedBox(height: 5),
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
