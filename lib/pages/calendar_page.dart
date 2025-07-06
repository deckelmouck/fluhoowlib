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

  @override
  void initState() {
    super.initState();
    _loadGelesenTage();
  }

  Future<void> _loadGelesenTage() async {
    final tage = await DatabaseHelper().getGelesenTage();
    setState(() {
      _gelesenTage.clear();
      _gelesenTage.addAll(tage);
    });
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
