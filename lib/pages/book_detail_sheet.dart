import 'package:flutter/material.dart';
import '../models/book.dart';
import '../db/database_helper.dart';

class BookDetailSheet extends StatelessWidget {
  final Book book;
  final VoidCallback onDelete;

  const BookDetailSheet({super.key, required this.book, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final bookMap = book.toMap();
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
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
                tooltip: 'Buch löschen',
                onPressed: () async {
                  if (book.id != null) {
                    await DatabaseHelper().deleteBook(book.id!);
                  }
                  onDelete();
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...bookMap.entries.map((e) => Text('${e.key}: ${e.value}')).toList(),
        ],
      ),
    );
  }
}
