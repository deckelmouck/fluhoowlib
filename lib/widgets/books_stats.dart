import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../models/book.dart';

class BooksStats extends StatelessWidget {
  final List<Book> books;

  const BooksStats({required this.books, super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final int totalBooks = books.length;
    final int uniqueAuthors = books.map((b) => b.author).toSet().length;
    final int readBooks = books.where((b) => b.readed).length;
    // Group read books by year
    final Map<int, int> booksReadPerYear = {};
    for (final book in books.where((b) => b.readed && b.finishedDate != null)) {
      final year = book.finishedDate!.year;
      booksReadPerYear[year] = (booksReadPerYear[year] ?? 0) + 1;
    }
    final sortedYears = booksReadPerYear.keys.toList()..sort();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${loc.booksInLibrary}: $totalBooks',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        Text(
          'Unique authors: $uniqueAuthors',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        Text(
          'Read books: $readBooks',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        SizedBox(height: 16),
        Text(
          'Books read per year:',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        ...sortedYears.map((year) => Text(
              '$year: ${booksReadPerYear[year]}',
              style: Theme.of(context).textTheme.bodySmall,
            )),
      ],
    );
  }
}
