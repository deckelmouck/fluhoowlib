import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../models/book.dart';

class BookListTile extends StatelessWidget {
  final Book book;
  final VoidCallback? onTap;

  const BookListTile({required this.book, this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return ListTile(
      title: Text(book.title),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('ID: ${book.id ?? "-"}'),
          Text('${loc.author}: ${book.author}'),
          Text('${loc.read}: ${book.readed ? loc.yes : loc.no}'),
          Text('${loc.rating}: ${book.rating}'),
          if (book.publicationDate != null)
            Text('${loc.publicationDate}: ${book.publicationDate!.year}-${book.publicationDate!.month.toString().padLeft(2, '0')}-${book.publicationDate!.day.toString().padLeft(2, '0')}'),
          if (book.finishedDate != null)
            Text('${loc.finishedDate} ${book.finishedDate!.year}-${book.finishedDate!.month.toString().padLeft(2, '0')}-${book.finishedDate!.day.toString().padLeft(2, '0')}'),
        ],
      ),
      onTap: onTap,
    );
  }
}