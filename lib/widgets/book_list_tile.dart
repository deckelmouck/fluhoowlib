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
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      book.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (book.readed)
                    Row(
                      children: [
                        ...List.generate(5, (i) => Icon(
                          i < book.rating ? Icons.star : Icons.star_border,
                          color: i < book.rating ? Colors.amber : Colors.grey,
                          size: 18,
                        )),
                      ],
                    ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.person, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      '${loc.author}: ${book.author}',
                      style: Theme.of(context).textTheme.bodySmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Icon(
                    book.readed ? Icons.check_circle : Icons.radio_button_unchecked,
                    size: 16,
                    color: book.readed ? Colors.green : Colors.grey,
                  ),
                  const SizedBox(width: 4),
                  Text('${loc.read}: ${book.readed ? loc.yes : loc.no}', style: Theme.of(context).textTheme.bodySmall),
                  const Spacer(),
                  if (book.publicationDate != null)
                    Row(
                      children: [
                        const Icon(Icons.calendar_today, size: 15, color: Colors.grey),
                        const SizedBox(width: 2),
                        Text('pub: ${book.publicationDate!.year}', style: Theme.of(context).textTheme.bodySmall),
                      ],
                    ),
                ],
              ),
              if (book.finishedDate != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Row(
                    children: [
                      const Icon(Icons.flag, size: 15, color: Colors.grey),
                      const SizedBox(width: 2),
                      Text(
                        'read: ${book.finishedDate!.year}-${book.finishedDate!.month.toString().padLeft(2, '0')}-${book.finishedDate!.day.toString().padLeft(2, '0')}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}