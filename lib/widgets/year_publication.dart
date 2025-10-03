import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

class PublicationYearPicker extends StatefulWidget {
  final DateTime? selectedYear;
  final ValueChanged<DateTime> onYearChanged;
  final String label;

  const PublicationYearPicker({
    super.key,
    required this.selectedYear,
    required this.onYearChanged,
    required this.label,
  });

  @override
  State<PublicationYearPicker> createState() => _PublicationYearPickerState();
}

class _PublicationYearPickerState extends State<PublicationYearPicker> {
  bool _showDetail = false;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Row(
      children: [
        Text('${widget.label} - '),
        Text(_showDetail ? loc.date : loc.year),
        const SizedBox(width: 8),
        Spacer(),
        TextButton(
          onPressed: () async {
            if (_showDetail) {
              // Full date picker
              final picked = await showDatePicker(
                context: context,
                initialDate: widget.selectedYear ?? DateTime.now(),
                firstDate: DateTime(1500),
                lastDate: DateTime.now(),
              );
              if (picked != null) {
                widget.onYearChanged(picked);
              }
            } else {
              // Year picker only
              final picked = await showDialog<DateTime>(
                context: context,
                builder: (context) {
                  DateTime tempSelected = widget.selectedYear ?? DateTime.now();
                  return AlertDialog(
                    title: Text(
                      Localizations.localeOf(context).languageCode == 'de'
                        ? '${loc.year} ${loc.choose}'
                        : '${loc.choose} ${loc.year}',
                    ),
                    content: SizedBox(
                      width: 300,
                      height: 400,
                      child: YearPicker(
                        selectedDate: tempSelected,
                        onChanged: (DateTime date) {
                          Navigator.of(context).pop(date);
                        },
                        firstDate: DateTime(1500),
                        lastDate: DateTime.now(),
                      ),
                    ),
                  );
                },
              );
              if (picked != null) {
                widget.onYearChanged(picked);
              }
            }
          },
      child: Text(
      widget.selectedYear != null
        ? (_showDetail
          ? '${widget.selectedYear!.day}.${widget.selectedYear!.month}.${widget.selectedYear!.year}'
          : '${widget.selectedYear!.year}')
        : (loc.choose),
      ),
        ),
        const SizedBox(width: 8),
        Switch(
          value: _showDetail,
          onChanged: (val) {
            setState(() {
              _showDetail = val;
            });
          },
        ),
      ],
    );
  }
}