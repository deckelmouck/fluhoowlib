import 'package:flutter/material.dart';
import '../models/book.dart';
import '../db/database_helper.dart';
import '../l10n/app_localizations.dart';

class BookDetailSheet extends StatelessWidget {
  final Book book;
  final VoidCallback onDelete;

  const BookDetailSheet({super.key, required this.book, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final bookMap = book.toMap();
    final loc = AppLocalizations.of(context)!;
    final fieldLabels = <String, String>{
      'id': 'Id',
      'title': loc.bookTitle,
      'author': loc.author,
      'readed': loc.read,
      'rating': loc.rating,
      // Add more fields as needed, fallback to key if not found
    };
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.66, // Two thirds of screen height
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    book.title,
                    style: Theme.of(context).textTheme.headlineSmall,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  tooltip: loc.deleteBook,
                  onPressed: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text(loc.deleteBook),
                        content: Text(loc.confirmDeleteBook),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: Text(loc.cancel),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: Text(loc.delete),
                          ),
                        ],
                      ),
                    );
                    if (confirm == true && book.id != null) {
                      await DatabaseHelper().deleteBook(book.id!);
                      onDelete();
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 32),
            Expanded(
              child: ListView(
                children: bookMap.entries.map((e) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 100, // Adjust width as needed
                        child: Text(
                          fieldLabels[e.key] ?? e.key,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          '${e.value}',
                          style: Theme.of(context).textTheme.bodyMedium,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                )).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
