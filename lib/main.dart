import 'package:flutter/material.dart';
import 'models/book.dart';
import 'pages/library_page.dart';
import 'pages/add_book_page.dart';
import 'pages/calendar_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';
import 'db/database_helper.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('en', ''), // English
        Locale('de', ''), // German
      ],
      home: TabBarExample(),
    );
  }
}

class TabBarExample extends StatefulWidget {
  const TabBarExample({super.key});

  @override
  State<TabBarExample> createState() => _TabBarExampleState();
}

class _TabBarExampleState extends State<TabBarExample> {
  int _selectedIndex = 0;
  List<Book> _books = [];
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  bool _gelesen = false;
  double _bewertung = 0;

  @override
  void initState() {
    super.initState();
    _loadBooks();
  }

  Future<void> _loadBooks() async {
    final books = await DatabaseHelper().getBooks();
    setState(() {
      _books = books;
    });
  }

  Future<void> _addBook() async {
    if (_titleController.text.isNotEmpty && _authorController.text.isNotEmpty) {
      final newBook = Book(
        title: _titleController.text,
        author: _authorController.text,
        gelesen: _gelesen,
        bewertung: _bewertung.round(),
      );
      await DatabaseHelper().insertBook(newBook);
      _titleController.clear();
      _authorController.clear();
      _gelesen = false;
      _bewertung = 0;
      _selectedIndex = 0;
      await _loadBooks();
    }
  }

  List<Widget> get _pages => [
        LibraryPage(books: _books),
        AddBookPage(
          titleController: _titleController,
          authorController: _authorController,
          gelesen: _gelesen,
          bewertung: _bewertung,
          onGelesenChanged: (val) {
            setState(() {
              _gelesen = val;
            });
          },
          onBewertungChanged: (val) {
            setState(() {
              _bewertung = val;
            });
          },
          onSave: _addBook,
        ),
        const CalendarPage(),
      ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: AppLocalizations.of(context)!.myLibrary,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: AppLocalizations.of(context)!.addBook,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: AppLocalizations.of(context)!.calendar,
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
