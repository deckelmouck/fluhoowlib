import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../db/database_helper.dart'; // Import your database helper
import '../l10n/app_localizations.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  final Set<DateTime> _readedDays = {};
  int _actualStreak = 0;
  int _longestStreak = 0;

  @override
  void initState() {
    super.initState();
    _loadReadedDays();
  }

  void _calculateStreaks() {
    if (_readedDays.isEmpty) {
      setState(() {
        _actualStreak = 0;
        _longestStreak = 0;
      });
      return;
    }
    final days = _readedDays.map((d) => DateTime(d.year, d.month, d.day)).toList();
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
    DateTime startDay = _readedDays.any((d) => d.year == today.year && d.month == today.month && d.day == today.day)
        ? today
        : today.subtract(const Duration(days: 1));
    while (_readedDays.any((d) => d.year == startDay.year && d.month == startDay.month && d.day == startDay.day)) {
      actual++;
      startDay = startDay.subtract(const Duration(days: 1));
    }
    setState(() {
      _longestStreak = longest;
      _actualStreak = actual;
    });
  }

  Future<void> _loadReadedDays() async {
    final days = await DatabaseHelper().getReadedDays();
    setState(() {
      _readedDays.clear();
      _readedDays.addAll(days);
    });
    _calculateStreaks();
  }

  Future<void> _toggleReadedDay(DateTime day) async {
    final normalized = DateTime(day.year, day.month, day.day);
    if (_readedDays.any((d) => isSameDay(d, normalized))) {
      await DatabaseHelper().deleteReadedDay(normalized);
      setState(() {
        _readedDays.removeWhere((d) => isSameDay(d, normalized));
      });
    } else {
      await DatabaseHelper().insertReadedDay(normalized);
      setState(() {
        _readedDays.add(normalized);
      });
    }
    _calculateStreaks();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return SafeArea(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            color: Colors.green,
            padding: const EdgeInsets.all(16.0),
            child: Text(
              loc.readingHabbit,
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          TableCalendar(
            firstDay: DateTime.utc(2000, 1, 1),
            lastDay: DateTime.utc(2100, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) {
              return _selectedDay != null && isSameDay(_selectedDay, day);
            },
            calendarFormat: CalendarFormat.month,
            locale: Localizations.localeOf(context).toString(),
            startingDayOfWeek: Localizations.localeOf(context).toString().startsWith('de')
                ? StartingDayOfWeek.monday
                : StartingDayOfWeek.sunday,
            availableCalendarFormats: {CalendarFormat.month: loc.month},
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
              final now = DateTime.now();
              final today = DateTime(now.year, now.month, now.day);
              final selected = DateTime(selectedDay.year, selectedDay.month, selectedDay.day);
              if (selected.isAfter(today)) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(loc.noFutureDays)),
                );
                return;
              }
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
              await _toggleReadedDay(selectedDay);
            },
            eventLoader: (day) {
              return _readedDays.any((d) => isSameDay(d, day)) ? [loc.read] : [];
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Column(
              children: [
                Text(loc.currentStreak(_actualStreak), style: Theme.of(context).textTheme.titleMedium),
                Text(loc.longestStreak(_longestStreak), style: Theme.of(context).textTheme.titleMedium),
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
                  final now = DateTime.now();
                  final today = DateTime(now.year, now.month, now.day);
                  setState(() {
                    _focusedDay = today;
                    _selectedDay = today;
                  });
                  await _toggleReadedDay(today);
                },
                child: Text(loc.todayRead),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
