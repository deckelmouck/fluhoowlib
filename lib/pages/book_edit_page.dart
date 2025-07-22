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

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.book.title);
    _authorController = TextEditingController(text: widget.book.author);
    _readed = widget.book.readed;
    _rating = widget.book.rating;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    final updatedBook = Book(
      id: widget.book.id,
      title: _titleController.text,
      author: _authorController.text,
      readed: _readed,
      rating: _rating,
    );
    await DatabaseHelper().updateBook(updatedBook);
    Navigator.of(context).pop(updatedBook);
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Book'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Edit details for: \\${widget.book.title}', style: const TextStyle(fontSize: 18)),
                const SizedBox(height: 16),
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _authorController,
                  decoration: const InputDecoration(labelText: 'Author'),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    const Text('Readed'),
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
                    const Text('Rating'),
                    Expanded(
                      child: Slider(
                        value: _rating.toDouble(),
                        min: 0,
                        max: 10,
                        divisions: 10,
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
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_titleController.text.trim().isEmpty || _authorController.text.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Title & Author must not be empty')),
                        );
                        return;
                      }
                      _saveChanges();
                    },
                    child: Text(loc.save),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
