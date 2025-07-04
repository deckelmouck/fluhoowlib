import 'package:flutter/material.dart';

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
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: titleController,
            decoration: const InputDecoration(labelText: 'Buchtitel'),
          ),
          TextField(
            controller: authorController,
            decoration: const InputDecoration(labelText: 'Autor'),
          ),
          Row(
            children: [
              const Text('Gelesen:'),
              Switch(
                value: gelesen,
                onChanged: onGelesenChanged,
              ),
            ],
          ),
          Row(
            children: [
              const Text('Bewertung:'),
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
              child: const Text('Speichern'),
            ),
          ),
        ],
      ),
    );
  }
}
