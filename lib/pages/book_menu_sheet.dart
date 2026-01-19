import 'package:flutter/material.dart';
import 'package:hoowlib/l10n/app_localizations.dart';
import 'package:hoowlib/models/book.dart';
import 'package:hoowlib/pages/book_edit_page.dart';
import 'package:hoowlib/providers/books_provider.dart';
import 'package:provider/provider.dart';


class BookMenuSheet extends StatelessWidget {
  final Book book;

  const BookMenuSheet({super.key, required this.book});

  @override
  Widget build(BuildContext context) {

    final loc = AppLocalizations.of(context)!;
    
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Align(
                  alignment: Alignment.center, 
                  child:  Text(
                    book.title, 
                    style: Theme.of(context).textTheme.headlineMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ]
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                book.author,
                style: Theme.of(context).textTheme.headlineSmall,)
            ],
          ),
          Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: TextButton.icon(
                  onPressed: () async {
                    Navigator.of(context).pop();
                    final bookProvider = context.read<BooksProvider>();
                    bookProvider.markAsRead(book);
                  }, 
                  label: Text(loc.markAsReaded), 
                  icon: const Icon(Icons.book),
                ),
              ),
            ],
          ),
          SizedBox(height: 8,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: TextButton.icon(
                  onPressed: () async {
                    Navigator.of(context).pop();
                    await Navigator.of(context).push<Book>(
                      MaterialPageRoute(
                        builder: (context) => BookEditPage(book: book),
                      ),
                    );
                  }, 
                  label: Text(loc.editBook), 
                  icon: const Icon(Icons.edit),
                ),
              ),
            ],
          ),
          SizedBox(height: 8,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: TextButton.icon(
                  onPressed: () async {
                    Navigator.of(context).pop();
                    final booksProvider = Provider.of<BooksProvider>(context, listen: false);
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
                            style: TextButton.styleFrom(
                              foregroundColor: Theme.of(context).colorScheme.error,
                            ),
                            child: Text(loc.delete),
                          ),
                        ],
                      ),
                    );
                    if (confirm == true && book.id != null) {
                      await booksProvider.deleteBook(book);
                    }
                  },
                  label: Text(loc.deleteBook),
                  icon: const Icon(Icons.delete),
                  style: TextButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.error,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}