import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../db/database_helper.dart'; // Import your database helper

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  final Set<DateTime> _gelesenTage = {};
  int _actualStreak = 0;
  int _longestStreak = 0;

  @override
  void initState() {
    super.initState();
    _loadGelesenTage();
  }

  void _calculateStreaks() {
    if (_gelesenTage.isEmpty) {
      setState(() {
        _actualStreak = 0;
        _longestStreak = 0;
      });
      return;
    }
    final days = _gelesenTage.map((d) => DateTime(d.year, d.month, d.day)).toList();
    days.sort((a, b) => a.compareTo(b));
    int longest = 1;
    int current = 1;
    for (int i = 1; i < days.length; i++) {
      if (days[i].difference(days[i - 1]).inDays == 1) {
        current++;
      } else if (!days[i].isAtSameMomentAs(days[i - 1])) {
        if (current > longest) longest = current;
        current = 1;
      }
    }
    if (current > longest) longest = current;
    // Adjusted actual streak calculation
    DateTime today = DateTime.now();
    int actual = 0;
    DateTime startDay = _gelesenTage.any((d) => d.year == today.year && d.month == today.month && d.day == today.day)
        ? today
        : today.subtract(const Duration(days: 1));
    while (_gelesenTage.any((d) => d.year == startDay.year && d.month == startDay.month && d.day == startDay.day)) {
      actual++;
      startDay = startDay.subtract(const Duration(days: 1));
    }
    setState(() {
      _longestStreak = longest;
      _actualStreak = actual;
    });
  }

  Future<void> _loadGelesenTage() async {
    final tage = await DatabaseHelper().getGelesenTage();
    setState(() {
      _gelesenTage.clear();
      _gelesenTage.addAll(tage);
    });
    _calculateStreaks();
  }

  Future<void> _toggleGelesenTag(DateTime day) async {
    final normalized = DateTime(day.year, day.month, day.day);
    if (_gelesenTage.any((d) => isSameDay(d, normalized))) {
      await DatabaseHelper().deleteGelesenTag(normalized);
      setState(() {
        _gelesenTage.removeWhere((d) => isSameDay(d, normalized));
      });
    } else {
      await DatabaseHelper().insertGelesenTag(normalized);
      setState(() {
        _gelesenTage.add(normalized);
      });
    }
    _calculateStreaks();
  }

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
          onDaySelected: (selectedDay, focusedDay) async {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
            await _toggleGelesenTag(selectedDay);
          },
          eventLoader: (day) {
            return _gelesenTage.any((d) => isSameDay(d, day)) ? ['gelesen'] : [];
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            children: [
              Text('Aktuelle Serie: $_actualStreak', style: Theme.of(context).textTheme.titleMedium),
              Text('Längste Serie: $_longestStreak', style: Theme.of(context).textTheme.titleMedium),
            ],
          ),
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                final today = DateTime(_focusedDay.year, _focusedDay.month, _focusedDay.day);
                await _toggleGelesenTag(today);
              },
              child: const Text('Heute gelesen'),
            ),
          ),
        ),
      ],
    );
  }
}
