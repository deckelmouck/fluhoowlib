import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

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
                      onChanged: _gelesen
                          ? (val) {
                              setState(() {
                                _bewertung = val;
                              });
                            }
                          : null,
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
        // Seite 3: Kalender und Button
        KalenderSeite(),
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

class KalenderSeite extends StatefulWidget {
  const KalenderSeite({super.key});

  @override
  State<KalenderSeite> createState() => _KalenderSeiteState();
}

class _KalenderSeiteState extends State<KalenderSeite> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  final Set<DateTime> _gelesenTage = {};

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TableCalendar(
          firstDay: DateTime.utc(2000, 1, 1),
          lastDay: DateTime.utc(2100, 12, 31),
          focusedDay: _focusedDay,
          selectedDayPredicate: (day) {
            return _selectedDay != null && isSameDay(_selectedDay, day);
          },
          calendarFormat: CalendarFormat.month,
          availableCalendarFormats: const {CalendarFormat.month: 'Monat'},
          calendarStyle: CalendarStyle(
            todayDecoration: BoxDecoration(
              color: Colors.blue.shade100,
              shape: BoxShape.circle,
            ),
            markerDecoration: BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
            ),
          ),
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
              final normalized = DateTime(selectedDay.year, selectedDay.month, selectedDay.day);
              if (_gelesenTage.any((d) => isSameDay(d, normalized))) {
                _gelesenTage.removeWhere((d) => isSameDay(d, normalized));
              } else {
                _gelesenTage.add(normalized);
              }
            });
          },
          eventLoader: (day) {
            return _gelesenTage.any((d) => isSameDay(d, day)) ? ['gelesen'] : [];
          },
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  final today = DateTime(_focusedDay.year, _focusedDay.month, _focusedDay.day);
                  if (_gelesenTage.any((d) => isSameDay(d, today))) {
                    _gelesenTage.removeWhere((d) => isSameDay(d, today));
                  } else {
                    _gelesenTage.add(today);
                  }
                });
              },
              child: const Text('Heute gelesen'),
            ),
          ),
        ),
      ],
    );
  }
}
