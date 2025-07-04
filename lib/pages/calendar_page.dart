import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

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
