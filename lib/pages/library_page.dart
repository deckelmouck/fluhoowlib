import 'package:flutter/material.dart';
import '../models/book.dart';
import 'book_detail_sheet.dart';
import '../db/database_helper.dart';

class LibraryPage extends StatefulWidget {
  final List<Book> books;
  const LibraryPage({super.key, required this.books});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  late List<Book> _books;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchBooks();
  }

  Future<void> _fetchBooks() async {
    setState(() => _loading = true);
    final books = await DatabaseHelper().getBooks();
    setState(() {
      _books = books;
      _loading = false;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fetchBooks();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    return Scrollbar(
      child: ListView.builder(
        itemCount: _books.length,
        itemBuilder: (context, index) {
          final book = _books[index];
          return ListTile(
            title: Text(book.title),
            subtitle: Text('Autor: ${book.author} | Gelesen: ${book.gelesen ? 'Ja' : 'Nein'} | Bewertung: ${book.bewertung}'),
            onTap: () async {
              final deleted = await showModalBottomSheet<bool>(
                context: context,
                builder: (context) => BookDetailSheet(
                  book: book,
                  onDelete: () {
                    Navigator.of(context).pop(true);
                  },
                ),
              );
              if (deleted == true) {
                await _fetchBooks();
              }
            },
          );
        },
      ),
    );
  }
}
