import 'package:flutter/material.dart';
import 'package:hoowlib/pages/book_menu_sheet.dart';
import 'package:hoowlib/providers/books_provider.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../models/book.dart';
import 'book_detail_sheet.dart';
import '../widgets/book_list_tile.dart';
import '../models/book_order_by.dart';
import 'book_edit_page.dart';
import 'add_newbook_page.dart';

class LibraryPage extends StatefulWidget {
  final List<Book> books;
  const LibraryPage({super.key, required this.books});

  @override
  LibraryPageState createState() => LibraryPageState();
}

class LibraryPageState extends State<LibraryPage> {
  BookOrderBy _orderBy = BookOrderBy.id;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onOrderChanged(BookOrderBy? value) {
    if (value != null && value != _orderBy) {
      setState(() {
        _orderBy = value;
      });
      context.read<BooksProvider>().sortBooks(_orderBy);
    }
  }

  @override
  Widget build(BuildContext context) {

    final loc = AppLocalizations.of(context)!;
    final books = context.watch<BooksProvider>().books;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(
            bottom: Radius.circular(10), // Adjust for more/less roundness
          ),
          child: AppBar(
            title: Text(
              loc.myLibrary,
              style: const TextStyle(color: Colors.white),
            ),
            actions: [
              IconButton.outlined(
                icon: const Icon(Icons.add, color: Colors.white,),
                tooltip: loc.addBook,
                onPressed: () async {
                  final booksProvider = context.read<BooksProvider>();
                  final newBook = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => AddNewbookPage()),
                  );
                  if (newBook != null) {
                    if (!mounted) return;
                    await booksProvider.addBook(newBook);
                  }
                },
              ),
              SizedBox(width: 10,),
            ],
            backgroundColor: Colors.brown,
            elevation: 4,
          ),
        ),
      ),      
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: Colors.transparent, // light smoky grey
              padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0),
              height: 44,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: SizedBox.expand(
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F5F5),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '${loc.booksInLibrary}: ${books.length}',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                    alignment: Alignment.centerRight,
                    child: DropdownButton<BookOrderBy>(
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
                      icon: const Icon(Icons.sort, color: Colors.black54),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ],
              ),
            ),
            // reduce space between top line and list
            Expanded(
              child: books.isEmpty
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
                          thumbVisibility: true, // Always show scrollbar
                        child: ListView.builder(
                          controller: _scrollController, // Attach controller
                          itemCount: books.length,
                          itemBuilder: (context, index) {
                            final book = books[index];
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
                                      height: MediaQuery.of(context).size.height * 0.4,
                                      child: BookMenuSheet(book: book),
                                      // BookDetailSheet(
                                      //   book: book,
                                      //   onDelete: () {
                                      //     Navigator.of(context).pop(true);
                                      //   },
                                      //   onEdit: () async {
                                      //     Navigator.of(context).pop();
                                      //     final updatedBook = await Navigator.of(context).push<Book>(
                                      //       MaterialPageRoute(
                                      //         builder: (context) => BookEditPage(book: book),
                                      //       ),
                                      //     );
                                      //     if (updatedBook != null) {
                                      //       //await fetchBooks();
                                      //       //didChangeDependencies();
                                      //     }
                                      //   },
                                      // ),
                                    ),
                                  );
                                  if (deleted == true) {
                                    //await fetchBooks();
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
      )
    );
  }
}
