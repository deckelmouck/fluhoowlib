import 'package:flutter/material.dart';
import 'package:hoowlib/pages/book_menu_sheet.dart';
import 'package:hoowlib/providers/books_provider.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../models/book.dart';
import '../widgets/book_list_tile.dart';
import '../models/book_order_by.dart';
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

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final background = theme.scaffoldBackgroundColor;
    final cardColor = theme.cardColor;
    final borderColor = theme.dividerColor;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(
            bottom: Radius.circular(10),
          ),
          child: AppBar(
            title: Text(
              loc.myLibrary,
              style: TextStyle(color: colorScheme.onPrimary),
            ),
            actions: [
              IconButton.outlined(
                icon: Icon(Icons.add, color: colorScheme.onPrimary),
                tooltip: loc.addBook,
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => AddNewbookPage()),
                  );
                },
              ),
              SizedBox(width: 10,),
            ],
            backgroundColor: colorScheme.primary,
            elevation: 4,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: Colors.transparent,
              padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0),
              height: 44,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: SizedBox.expand(
                      child: Container(
                        decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: borderColor),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '${loc.booksInLibrary}: ${books.length}',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: theme.textTheme.bodyLarge?.color),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Container(
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: borderColor),
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
                      style: TextStyle(fontWeight: FontWeight.normal, color: theme.textTheme.bodyLarge?.color, fontSize: 14),
                      icon: Icon(Icons.sort, color: theme.iconTheme.color),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: books.isEmpty
                  ? Center(
                      child: Text(
                        loc.noBooks,
                        style: TextStyle(fontSize: 18, color: colorScheme.onSurfaceVariant),
                        textAlign: TextAlign.center,
                      ),
                    )
                  : Container(
                      color: background,
                      child: Scrollbar(
                        controller: _scrollController,
                        thumbVisibility: true,
                        child: ListView.builder(
                          controller: _scrollController,
                          itemCount: books.length,
                          itemBuilder: (context, index) {
                            final book = books[index];
                            return Container(
                              color: colorScheme.surface,
                              child: BookListTile(
                                book: book,
                                onTap: () async {
                                  await showModalBottomSheet<bool>(
                                    context: context,
                                    isScrollControlled: true,
                                    builder: (context) => SizedBox(
                                      height: MediaQuery.of(context).size.height * 0.4,
                                      child: BookMenuSheet(book: book),
                                    ),
                                  );
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
      ),
    );
  }
}
