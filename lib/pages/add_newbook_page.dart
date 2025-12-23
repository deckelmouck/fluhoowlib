import 'package:flutter/material.dart';
import 'package:hoowlib/models/book.dart';
import '../l10n/app_localizations.dart';

class AddNewbookPage extends StatefulWidget {
  const AddNewbookPage({super.key});

  @override
  AddNewbookPageState createState() => AddNewbookPageState();
}

class AddNewbookPageState extends State<AddNewbookPage> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _author = '';
  DateTime? _publicationDate = DateTime.now();
  bool _readed = false;
  double _rating = 0;
  DateTime? _finishedDate;

  void _onPublicationDateChanged(DateTime? date) {
    setState(() {
      _publicationDate = date;
    });
  }

  void _onReadedChanged(bool value) {
    setState(() {
      _readed = value;
      if (!value) {
        _rating = 0; // Reset rating if not read
      }
    });
  }

  void _onRatingChanged(double value) {
    setState(() {
      _rating = value;
    });
  }

  void _onFinishedDateChanged(DateTime? date) {
    setState(() {
      _finishedDate = date;
    });
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          loc.addNewBook,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: loc.bookTitle),
                  textCapitalization: TextCapitalization.sentences,
                  onSaved: (value) => _title = value ?? '',
                  validator: (value) => value!.isEmpty ? loc.enterTitle : null,
                ),
                SizedBox(height: 16),
                TextFormField(
                  decoration: InputDecoration(labelText: loc.author),
                  textCapitalization: TextCapitalization.words,
                  onSaved: (value) => _author = value ?? '',
                  validator: (value) => value!.isEmpty ? loc.enterAuthor : null,
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Text(loc.publicationDateShort),
                    Spacer(),
                    TextButton(
                      child: Text(_publicationDate.toString().substring(0, 4)),
                      onPressed: () async {
                        final picked = await showDialog<DateTime>(
                          context: context,
                          builder: (context) {
                            DateTime tempSelected =
                                _publicationDate ?? DateTime.now();
                            return AlertDialog(
                              title: Text(
                                Localizations.localeOf(context).languageCode ==
                                        'de'
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
                          _onPublicationDateChanged(picked);
                        }
                      },
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Text(loc.read),
                    Spacer(),
                    Switch(value: _readed, onChanged: _onReadedChanged),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Text(loc.rating),
                    Expanded(
                      child: Slider(
                        value: _rating,
                        min: 0,
                        max: 5,
                        divisions: 5,
                        label: _rating.round().toString(),
                        onChanged: _readed ? _onRatingChanged : null,
                      ),
                    ),
                    Text(_rating.round().toString()),
                  ],
                ),
                SizedBox(height: 20),
                // Finished Date Picker
                Row(
                  children: [
                    Text(loc.finishedDate),
                    Spacer(),
                    TextButton(
                      onPressed: _readed
                          ? () async {
                              final picked = await showDatePicker(
                                context: context,
                                initialDate: _finishedDate ?? DateTime.now(),
                                firstDate: DateTime(1500),
                                lastDate: DateTime.now(),
                              );
                              if (picked != null) {
                                _onFinishedDateChanged(picked);
                              }
                            }
                          : null,
                      child: Text(
                        _finishedDate != null
                            ? '${_finishedDate!.day}.${_finishedDate!.month}.${_finishedDate!.year}'
                            : loc.selectDate,
                      ),
                    ),
                  ],
                ),
                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      child: Text(loc.cancel),
                      onPressed: () => Navigator.pop(context),
                    ),
                    ElevatedButton(
                      child: Text(loc.save),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          final book = Book(
                            title: _title,
                            author: _author,
                            readed: _readed,
                            rating: _rating.round(),
                            publicationDate: _publicationDate,
                            finishedDate: _finishedDate,
                          );
                          Navigator.pop(context, book); // Pass book back
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
