import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

class AddBookPage extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController authorController;
  final bool gelesen;
  final double bewertung;
  final ValueChanged<bool> onGelesenChanged;
  final ValueChanged<double> onBewertungChanged;
  final VoidCallback onSave;

  const AddBookPage({
    super.key,
    required this.titleController,
    required this.authorController,
    required this.gelesen,
    required this.bewertung,
    required this.onGelesenChanged,
    required this.onBewertungChanged,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: titleController,
            decoration: InputDecoration(labelText: loc.bookTitle),
          ),
          TextField(
            controller: authorController,
            decoration: InputDecoration(labelText: loc.author),
          ),
          Row(
            children: [
              Text(loc.read),
              Switch(
                value: gelesen,
                onChanged: onGelesenChanged,
              ),
            ],
          ),
          Row(
            children: [
              Text(loc.rating),
              Expanded(
                child: Slider(
                  value: bewertung,
                  min: 0,
                  max: 10,
                  divisions: 10,
                  label: bewertung.round().toString(),
                  onChanged: gelesen ? onBewertungChanged : null,
                ),
              ),
              Text(bewertung.round().toString()),
            ],
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onSave,
              child: Text(loc.save),
            ),
          ),
        ],
      ),
    );
  }
}
