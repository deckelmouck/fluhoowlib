import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../l10n/app_localizations.dart';

class AddBookPage extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController authorController;
  final bool readed;
  final double rating;
  final DateTime? publicationDate;
  final DateTime? finishedDate;
  final ValueChanged<bool> onReadedChanged;
  final ValueChanged<double> onRatingChanged;
  final ValueChanged<DateTime?> onPublicationDateChanged;
  final ValueChanged<DateTime?> onFinishedDateChanged;
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
    required this.publicationDate,
    required this.finishedDate,
    required this.onPublicationDateChanged,
    required this.onFinishedDateChanged,
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
                  loc.addNewBook,
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
                      inputFormatters: [UpperCaseFirstLetterFormatter()],
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: authorController,
                      decoration: InputDecoration(labelText: loc.author),
                      inputFormatters: [UpperCaseFirstLetterFormatter()],
                    ),
                    SizedBox(height: 20),
                    // Publication Date Picker
                    Row(
                      children: [
                        Text(loc.publicationDate),
                        Spacer(),
                        TextButton(
                          onPressed: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: publicationDate ?? DateTime.now(),
                              firstDate: DateTime(1500),
                              lastDate: DateTime.now(),
                            );
                            if (picked != null) onPublicationDateChanged(picked);
                          },
                          child: Text(publicationDate != null
                              ? '${publicationDate!.day}.${publicationDate!.month}.${publicationDate!.year}'
                              : loc.selectDate),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Text(loc.read),
                        Spacer(),
                        Switch(
                          value: readed,
                          onChanged: onReadedChanged,
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
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
                    SizedBox(height: 20),
                    // Finished Date Picker
                    Row(
                      children: [
                        Text(loc.finishedDate),
                        Spacer(),
                        TextButton(
                          onPressed: readed
                              ? () async {
                                  final picked = await showDatePicker(
                                    context: context,
                                    initialDate: finishedDate ?? DateTime.now(),
                                    firstDate: DateTime(1500),
                                    lastDate: DateTime.now(),
                                  );
                                  if (picked != null) onFinishedDateChanged(picked);
                                }
                              : null,
                          child: Text(finishedDate != null
                              ? '${finishedDate!.day}.${finishedDate!.month}.${finishedDate!.year}'
                              : loc.selectDate),
                        ),
                      ],
                    ),
                    SizedBox(height: 32),
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

class UpperCaseFirstLetterFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) return newValue;
    final text = newValue.text;
    final capitalized = text[0].toUpperCase() + text.substring(1);
    return newValue.copyWith(
      text: capitalized,
      selection: newValue.selection,
    );
  }
}
