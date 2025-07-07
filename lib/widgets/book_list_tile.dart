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
          Text('${loc.author}: ${book.author}'),
          if (book.readed)
            Text('${loc.read} ${loc.yes} | ${loc.rating} ${book.rating}')
          else
            Text('${loc.read} ${loc.no}'),
        ],
      ),
      onTap: onTap,
    );
  }
}