import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../models/book.dart';
import 'book_detail_sheet.dart';
import '../db/database_helper.dart';
import '../widgets/book_list_tile.dart';
import '../models/book_order_by.dart';
import 'book_edit_page.dart';

class LibraryPage extends StatefulWidget {
  final List<Book> books;
  const LibraryPage({super.key, required this.books});

  @override
  LibraryPageState createState() => LibraryPageState();
}

class LibraryPageState extends State<LibraryPage> {
  late List<Book> _books;
  bool _loading = true;
  BookOrderBy _orderBy = BookOrderBy.id;
  final ScrollController _scrollController = ScrollController(); // Add this

  @override
  void initState() {
    super.initState();
    fetchBooks();
  }

  @override
  void dispose() {
    _scrollController.dispose(); // Dispose controller
    super.dispose();
  }

  Future<void> fetchBooks() async {
    setState(() => _loading = true);
    final books = await DatabaseHelper().getBooks();
    setState(() {
      _books = books;
      _loading = false;
    });
  }

  void _onOrderChanged(BookOrderBy? value) {
    if (value != null && value != _orderBy) {
      setState(() {
        _orderBy = value;
        if (_orderBy == BookOrderBy.id) {
          _books.sort((a, b) => (a.id ?? 0).compareTo(b.id ?? 0));
        } else if (_orderBy == BookOrderBy.title) {
          _books.sort((a, b) => a.title.compareTo(b.title));
        } else if (_orderBy == BookOrderBy.author) {
          _books.sort((a, b) => a.author.compareTo(b.author));
        } else if (_orderBy == BookOrderBy.rating) {
          _books.sort((a, b) => b.rating.compareTo(a.rating)); // Descending order
        }
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchBooks();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    final loc = AppLocalizations.of(context)!;
    return SafeArea(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            color: Colors.green,
            padding: const EdgeInsets.all(16.0),
            child: Text(
              loc.myLibrary,
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            color: const Color(0xFFF5F5F5), // light smoky grey
            padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 12.0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    '${loc.booksInLibrary}: ${_books.length}',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                DropdownButton<BookOrderBy>(
                  value: _orderBy,
                  onChanged: _onOrderChanged,
                  items: BookOrderBy.values
                      .map((order) => DropdownMenuItem(
                            value: order,
                            child: Text(order.translatedName(loc)),
                          ))
                      .toList(),
                  underline: Container(),
                  style: const TextStyle(fontWeight: FontWeight.normal, color: Colors.black, fontSize: 14),
                ),
              ],
            ),
          ),
          // reduce space between top line and list
          Expanded(
            child: _books.isEmpty
                ? Center(
                    child: Text(
                      loc.noBooks,
                      style: const TextStyle(fontSize: 18, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  )
                : Container(
                    color: Colors.white,
                    child: Scrollbar(
                      controller: _scrollController, // Attach controller
                      child: ListView.builder(
                        controller: _scrollController, // Attach controller
                        itemCount: _books.length,
                        itemBuilder: (context, index) {
                          final book = _books[index];
                          final isEven = index % 2 == 0;
                          return Container(
                            color: isEven ? Colors.white : Colors.grey[50],
                            child: BookListTile(
                              book: book,
                              onTap: () async {
                                final deleted = await showModalBottomSheet<bool>(
                                  context: context,
                                  isScrollControlled: true,
                                  builder: (context) => SizedBox(
                                    height: MediaQuery.of(context).size.height * 0.8,
                                    child: BookDetailSheet(
                                      book: book,
                                      onDelete: () {
                                        Navigator.of(context).pop(true);
                                      },
                                      onEdit: () async {
                                        Navigator.of(context).pop();
                                        final updatedBook = await Navigator.of(context).push<Book>(
                                          MaterialPageRoute(
                                            builder: (context) => BookEditPage(book: book),
                                          ),
                                        );
                                        if (updatedBook != null) {
                                          await fetchBooks();
                                        }
                                      },
                                    ),
                                  ),
                                );
                                if (deleted == true) {
                                  await fetchBooks();
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
      ),
    );
  }
}
