import 'package:flutter/material.dart';

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

class Book {
  final String title;
  final String author;
  final bool gelesen;
  final int bewertung;

  Book({required this.title, required this.author, required this.gelesen, required this.bewertung});
}

class _TabBarExampleState extends State<TabBarExample> {
  int _selectedIndex = 0;

  final List<Book> _books = [];

  // Controller für Seite 2
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  bool _gelesen = false;
  double _bewertung = 0;

  List<Widget> get _pages => [
        // Seite 1: Liste der Bücher
        ListView.builder(
          itemCount: _books.length,
          itemBuilder: (context, index) {
            final book = _books[index];
            return ListTile(
              title: Text(book.title),
              subtitle: Text('Autor: \\${book.author} | Gelesen: \\${book.gelesen ? 'Ja' : 'Nein'} | Bewertung: \\${book.bewertung}'),
            );
          },
        ),
        // Seite 2: Eingabeformular
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Buchtitel'),
              ),
              TextField(
                controller: _authorController,
                decoration: const InputDecoration(labelText: 'Autor'),
              ),
              Row(
                children: [
                  const Text('Gelesen:'),
                  Switch(
                    value: _gelesen,
                    onChanged: (val) {
                      setState(() {
                        _gelesen = val;
                      });
                    },
                  ),
                ],
              ),
              Row(
                children: [
                  const Text('Bewertung:'),
                  Expanded(
                    child: Slider(
                      value: _bewertung,
                      min: 0,
                      max: 10,
                      divisions: 10,
                      label: _bewertung.round().toString(),
                      onChanged: (val) {
                        setState(() {
                          _bewertung = val;
                        });
                      },
                    ),
                  ),
                  Text(_bewertung.round().toString()),
                ],
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
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
                  child: const Text('Speichern'),
                ),
              ),
            ],
          ),
        ),
        // Seite 3 bleibt wie gehabt
        const Center(child: Text('Seite 3')),
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
            label: 'Seite 1',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Seite 2',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Seite 3',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
