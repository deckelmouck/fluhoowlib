import 'package:flutter/material.dart';
import 'models/book.dart';
import 'pages/library_page.dart';
import 'pages/add_book_page.dart';
import 'pages/calendar_page.dart';
import 'pages/setting_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';
import 'db/database_helper.dart';
import 'dart:ui' as ui;

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  Locale? _locale;

  @override
  void initState() {
    super.initState();
    // Set initial locale to system default
    final systemLocale = ui.PlatformDispatcher.instance.locale;
    if (["en", "de"].contains(systemLocale.languageCode)) {
      _locale = Locale(systemLocale.languageCode);
    } else {
      _locale = const Locale('en');
    }
  }

  void _changeLocale(Locale newLocale) {
    setState(() {
      _locale = newLocale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: _locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''),
        Locale('de', ''),
      ],
      home: MainNavigation(onLocaleChanged: _changeLocale),
    );
  }
}

class MainNavigation extends StatefulWidget {
  final void Function(Locale)? onLocaleChanged;
  const MainNavigation({super.key, this.onLocaleChanged});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;
  List<Book> _books = [];
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  bool _readed = false;
  double _rating = 0;

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
        readed: _readed,
        rating: _rating.round(),
      );
      await DatabaseHelper().insertBook(newBook);
      _titleController.clear();
      _authorController.clear();
      _readed = false;
      _rating = 0;
      _selectedIndex = 0;
      await _loadBooks();
    }
  }

  void _onReadedChanged(bool value) {
    setState(() {
      _readed = value;
    });
  }

  void _onRatingChanged(double value) {
    setState(() {
      _rating = value;
    });
  }

  void _onSave() async {
    await _addBook();
  }

  List<Widget> get _pages => [
        LibraryPage(books: _books),
        AddBookPage(
          titleController: _titleController,
          authorController: _authorController,
          readed: _readed,
          rating: _rating,
          onReadedChanged: _onReadedChanged,
          onRatingChanged: _onRatingChanged,
          onSave: _onSave,
        ),
        const CalendarPage(),
        SettingPage(onLocaleChanged: widget.onLocaleChanged),
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
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 24),
            label: AppLocalizations.of(context)!.myLibrary,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add, size: 24),
            label: AppLocalizations.of(context)!.addBook,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month, size: 24),
            label: AppLocalizations.of(context)!.calendar,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings, size: 24),
            label: AppLocalizations.of(context)!.settings,
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
