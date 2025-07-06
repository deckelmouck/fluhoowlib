import 'package:flutter/material.dart';
import '../models/book.dart';

class LibraryPage extends StatelessWidget {
  final List<Book> books;
  const LibraryPage({super.key, required this.books});

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: ListView.builder(
        itemCount: books.length,
        itemBuilder: (context, index) {
          final book = books[index];
          return ListTile(
            title: Text(book.title),
            subtitle: Text('Autor: ${book.author} | Gelesen: ${book.gelesen ? 'Ja' : 'Nein'} | Bewertung: ${book.bewertung}'),
          );
        },
      ),
    );
  }
}
