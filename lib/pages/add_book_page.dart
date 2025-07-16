import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

class AddBookPage extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController authorController;
  final bool readed;
  final double rating;
  final ValueChanged<bool> onReadedChanged;
  final ValueChanged<double> onRatingChanged;
  final VoidCallback onSave;

  const AddBookPage({
    super.key,
    required this.titleController,
    required this.authorController,
    required this.readed,
    required this.rating,
    required this.onReadedChanged,
    required this.onRatingChanged,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                color: Colors.green,
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'add new book',
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
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
                          value: readed,
                          onChanged: onReadedChanged,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(loc.rating),
                        Expanded(
                          child: Slider(
                            value: rating,
                            min: 0,
                            max: 10,
                            divisions: 10,
                            label: rating.round().toString(),
                            onChanged: readed ? onRatingChanged : null,
                          ),
                        ),
                        Text(rating.round().toString()),
                      ],
                    ),
                    SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Row(
          children: [
            Expanded(
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (titleController.text.trim().isEmpty || authorController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${loc.bookTitle} & ${loc.author} ${loc.mustNotBeEmpty}'),
                        ),
                      );
                      return;
                    }
                    onSave();
                  },
                  child: Text(loc.save),
                ),
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () {
                titleController.clear();
                authorController.clear();
                onReadedChanged(false);
                onRatingChanged(0);
              },
              child: Text(loc.clear),
            ),
          ],
        ),
      ),
    );
  }
}
