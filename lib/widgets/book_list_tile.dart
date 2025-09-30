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
          // First row: author full width
          Text('${loc.author}: ${book.author}'),
          // Second row: readed left, rating right
          Row(
            children: [
              Expanded(
                child: Text('${loc.read}: ${book.readed ? loc.yes : loc.no}'),
              ),
              Expanded(
                child: book.readed
                  ? Row(
                      children: [
                        ...List.generate(5, (i) => Icon(
                          i < book.rating ? Icons.star : Icons.star_border,
                          color: i < book.rating ? Colors.amber : Colors.grey,
                          size: 16,
                        )),
                      ],
                    )
                  : Container(),
              ),
            ],
          ),
          // Third row: publication date left, finished date right
          Row(
            children: [
              Expanded(
                child: book.publicationDate != null
                  ? Text('pub: ${book.publicationDate!.year}')
                  : Container(),
              ),
              Expanded(
                child: book.finishedDate != null
                  ? Text('read: ${book.finishedDate!.year}-${book.finishedDate!.month.toString().padLeft(2, '0')}-${book.finishedDate!.day.toString().padLeft(2, '0')}')
                  : Container(),
              ),
            ],
          ),
        ],
      ),
      onTap: onTap,
    );
  }
}