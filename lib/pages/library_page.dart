import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
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
  String _orderBy = 'id';

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

  void _onOrderChanged(String? value) {
    if (value != null && value != _orderBy) {
      setState(() {
        _orderBy = value;
        // Optionally, sort _books here if needed
        if (_orderBy == 'id') {
          _books.sort((a, b) => (a.id ?? 0).compareTo(b.id ?? 0));
        } else if (_orderBy == 'title') {
          _books.sort((a, b) => a.title.compareTo(b.title));
        } else if (_orderBy == 'author') {
          _books.sort((a, b) => a.author.compareTo(b.author));
        }
      });
    }
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
    return Column(
      children: [
        SafeArea(
          bottom: false,
          child: Container(
            color: const Color(0xFFF5F5F5), // light smoky grey
            padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 12.0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Bücher in der Bibliothek: ${_books.length}',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                DropdownButton<String>(
                  value: _orderBy,
                  onChanged: _onOrderChanged,
                  items: const [
                    DropdownMenuItem(value: 'id', child: Text('ID')),
                    DropdownMenuItem(value: 'title', child: Text('Titel')),
                    DropdownMenuItem(value: 'author', child: Text('Autor')),
                  ],
                  underline: Container(),
                  style: const TextStyle(fontWeight: FontWeight.normal, color: Colors.black, fontSize: 14),
                ),
              ],
            ),
          ),
        ),
        // reduce space between top line and list
        Expanded(
          child: Container(
            color: Colors.white,
            child: Scrollbar(
              child: ListView.builder(
                itemCount: _books.length,
                itemBuilder: (context, index) {
                  final book = _books[index];
                  final isEven = index % 2 == 0;
                  return Container(
                    color: isEven ? Colors.white : Colors.grey[50],
                    child: _BookListTile(
                      book: book,
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
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _BookListTile extends StatelessWidget {
  final Book book;
  final VoidCallback? onTap;

  const _BookListTile({required this.book, this.onTap});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return ListTile(
      title: Text(book.title),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${loc.author}: ${book.author}'),
          if (book.gelesen)
            Text('${loc.read} ${loc.yes} | ${loc.rating} ${book.bewertung}')
          else
            Text('${loc.read} ${loc.no}'),
        ],
      ),
      onTap: onTap,
    );
  }
}
