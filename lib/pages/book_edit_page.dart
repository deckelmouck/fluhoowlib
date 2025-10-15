import 'package:flutter/material.dart';
import '../models/book.dart';
import '../db/database_helper.dart';
import '../l10n/app_localizations.dart';

class BookEditPage extends StatefulWidget {
  final Book book;
  const BookEditPage({super.key, required this.book});

  @override
  State<BookEditPage> createState() => _BookEditPageState();
}

class _BookEditPageState extends State<BookEditPage> {
  late TextEditingController _titleController;
  late TextEditingController _authorController;
  late bool _readed;
  late int _rating;
  late DateTime? _publicationDate;
  late DateTime? _finishedDate;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.book.title);
    _authorController = TextEditingController(text: widget.book.author);
    _readed = widget.book.readed;
    _rating = widget.book.rating;
    _publicationDate = widget.book.publicationDate;
    _finishedDate = widget.book.finishedDate;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    super.dispose();
  }

  Future<void> _pickDate({required DateTime? initialDate, required ValueChanged<DateTime?> onDatePicked}) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: DateTime(1500),
      lastDate: DateTime(2100),
    );
    onDatePicked(picked);
  }

  Future<void> _saveChanges() async {
    final updatedBook = Book(
      id: widget.book.id,
      title: _titleController.text,
      author: _authorController.text,
      readed: _readed,
      rating: _rating,
      publicationDate: _publicationDate,
      finishedDate: _finishedDate,
    );
    await DatabaseHelper().updateBook(updatedBook);
    if (!mounted) return;
    Navigator.of(context).pop(updatedBook);
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(loc.editBook),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                TextField(
                  controller: _titleController,
                  decoration: InputDecoration(labelText: loc.bookTitle),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _authorController,
                  decoration: InputDecoration(labelText: loc.author),
                ),
                const SizedBox(height: 20),
                ListTile(
                  title: Text(loc.publicationDate),
                  subtitle: Text(_publicationDate != null ? _publicationDate!.toLocal().toString().split(' ')[0] : loc.noDateSelected),
                  trailing: Icon(Icons.calendar_today),
                  onTap: () => _pickDate(
                    initialDate: _publicationDate,
                    onDatePicked: (date) {
                      setState(() {
                        _publicationDate = date;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Text(loc.read),
                    const Spacer(),
                    Switch(
                      value: _readed,
                      onChanged: (val) {
                        setState(() {
                          _readed = val;
                          if (!_readed) _rating = 0;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Text(loc.rating),
                    Expanded(
                      child: Slider(
                        value: _rating.toDouble(),
                        min: 0,
                        max: 5,
                        divisions: 5,
                        label: _rating.toString(),
                        onChanged: _readed
                            ? (val) {
                                setState(() {
                                  _rating = val.round();
                                });
                              }
                            : null,
                      ),
                    ),
                    Text(_rating.toString()),
                  ],
                ),
                const SizedBox(height: 20),
                ListTile(
                  title: Text(loc.finishedDate),
                  subtitle: Text(_finishedDate != null ? _finishedDate!.toLocal().toString().split(' ')[0] : loc.noDateSelected),
                  trailing: Icon(Icons.calendar_today),
                  enabled: _readed,
                  onTap: _readed
                      ? () => _pickDate(
                          initialDate: _finishedDate,
                          onDatePicked: (date) {
                            setState(() {
                              _finishedDate = date;
                            });
                          },
                        )
                      : null,
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (_titleController.text.trim().isEmpty || _authorController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(loc.warningTitleAuthorNotEmpty)),
                  );
                  return;
                }
                _saveChanges();
              },
              child: Text(loc.save),
            ),
          ),
        ),
      ),
    );
  }
}
