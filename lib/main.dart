import 'package:flutter/material.dart';
import 'models/book.dart';
import 'pages/library_page.dart';
import 'pages/add_book_page.dart';
import 'pages/calendar_page.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
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
  final List<Book> _books = [];
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  bool _gelesen = false;
  double _bewertung = 0;

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
          onSave: () {
            if (_titleController.text.isNotEmpty && _authorController.text.isNotEmpty) {
              setState(() {
                _books.add(Book(
                  title: _titleController.text,
                  author: _authorController.text,
                  gelesen: _gelesen,
                  bewertung: _bewertung.round(),
                ));
                _titleController.clear();
                _authorController.clear();
                _gelesen = false;
                _bewertung = 0;
                _selectedIndex = 0;
              });
            }
          },
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
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Meine Bibliothek',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Buch hinzufügen',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: 'Kalender',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
