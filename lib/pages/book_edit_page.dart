import 'package:flutter/material.dart';
import 'package:hoowlib/providers/books_provider.dart';
import 'package:hoowlib/services/book_cover_service.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import '../models/book.dart';
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
  late TextEditingController _isbnController;
  late bool _borrowed;
  late TextEditingController _borrowedByController;
  late DateTime? _borrowedDate;
  late TextEditingController _notesController;
  late String? _coverImagePath;
  late String? _originalCoverImagePath;
  final BookCoverService _coverService = BookCoverService();
  bool _saved = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.book.title);
    _authorController = TextEditingController(text: widget.book.author);
    _readed = widget.book.readed;
    _rating = widget.book.rating;
    _publicationDate = widget.book.publicationDate;
    _finishedDate = widget.book.finishedDate;
    _isbnController = TextEditingController(text: widget.book.isbn);
    _borrowed = widget.book.borrowed;
    _borrowedByController = TextEditingController(
      text: widget.book.borrowedBy ?? '',
    );
    _borrowedDate = widget.book.borrowedDate;
    _notesController = TextEditingController(text: widget.book.notes);
    _coverImagePath = widget.book.coverImagePath;
    _originalCoverImagePath = widget.book.coverImagePath;
  }

  @override
  void dispose() {
    if (!_saved &&
        _coverImagePath != null &&
        _coverImagePath != _originalCoverImagePath) {
      BookCoverService.deleteImageAtPath(_coverImagePath);
    }
    _titleController.dispose();
    _authorController.dispose();
    _isbnController.dispose();
    _borrowedByController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickCoverFromCamera() async {
    final loc = AppLocalizations.of(context)!;
    try {
      final newPath = await _coverService.pickFromCameraAndStore();
      if (newPath == null) {
        return;
      }
      final previousPath = _coverImagePath;
      if (previousPath != null && previousPath != _originalCoverImagePath) {
        await BookCoverService.deleteImageAtPath(previousPath);
      }
      if (!mounted) return;
      setState(() {
        _coverImagePath = newPath;
      });
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(loc.imageSelectionFailed)));
    }
  }

  Future<void> _pickCoverFromGallery() async {
    final loc = AppLocalizations.of(context)!;
    try {
      final newPath = await _coverService.pickFromGalleryAndStore();
      if (newPath == null) {
        return;
      }
      final previousPath = _coverImagePath;
      if (previousPath != null && previousPath != _originalCoverImagePath) {
        await BookCoverService.deleteImageAtPath(previousPath);
      }
      if (!mounted) return;
      setState(() {
        _coverImagePath = newPath;
      });
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(loc.imageSelectionFailed)));
    }
  }

  Future<void> _showImageSourceSheet() async {
    final loc = AppLocalizations.of(context)!;
    await showModalBottomSheet<void>(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: Text(loc.takePicture),
                onTap: () async {
                  Navigator.of(context).pop();
                  await _pickCoverFromCamera();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: Text(loc.chooseFromGallery),
                onTap: () async {
                  Navigator.of(context).pop();
                  await _pickCoverFromGallery();
                },
              ),
              if (_coverImagePath != null)
                ListTile(
                  leading: const Icon(Icons.delete_outline),
                  title: Text(loc.removePicture),
                  onTap: () {
                    Navigator.of(context).pop();
                    setState(() {
                      _coverImagePath = null;
                    });
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickDate({
    required DateTime? initialDate,
    required ValueChanged<DateTime?> onDatePicked,
  }) async {
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
      isbn: _isbnController.text,
      borrowed: _borrowed,
      borrowedBy: _borrowed ? _borrowedByController.text : null,
      borrowedDate: _borrowed ? _borrowedDate : null,
      notes: _notesController.text,
      coverImagePath: _coverImagePath,
    );
    _saved = true;
    if (_originalCoverImagePath != null &&
        _originalCoverImagePath != _coverImagePath) {
      await BookCoverService.deleteImageAtPath(_originalCoverImagePath);
    }
    if (!mounted) return;
    final bookProvider = context.read<BooksProvider>();
    bookProvider.updateBook(updatedBook);
    Navigator.of(context).pop(updatedBook);
  }

  bool _validateSave() {
    if (_isbnController.text.isNotEmpty &&
        !RegExp(
          r'^(([0-9Xx][- ]?){13}|([0-9Xx][- ]?){10})$',
        ).hasMatch(_isbnController.text)) {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final snackBar = SnackBar(
      content: Text(loc.invalidIsbnNo),
      duration: Durations.medium2,
      backgroundColor: Colors.red,
    );
    return Scaffold(
      appBar: AppBar(title: Text(loc.editBook)),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  child: ListTile(
                    leading: _coverImagePath != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: Image.file(
                              File(_coverImagePath!),
                              width: 48,
                              height: 48,
                              fit: BoxFit.cover,
                              errorBuilder: (_, error, stackTrace) =>
                                  const Icon(Icons.broken_image, size: 32),
                            ),
                          )
                        : const Icon(Icons.image_outlined),
                    title: Text(loc.bookCover),
                    subtitle: Text(
                      _coverImagePath == null
                          ? loc.noPictureSelected
                          : loc.pictureSelected,
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: _showImageSourceSheet,
                      tooltip: loc.addPicture,
                    ),
                    onTap: _showImageSourceSheet,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _titleController,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(labelText: loc.bookTitle),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _authorController,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(labelText: loc.author),
                ),
                const SizedBox(height: 20),
                ListTile(
                  title: Text(loc.publicationDate),
                  subtitle: Text(
                    _publicationDate != null
                        ? _publicationDate!.toLocal().toString().split(' ')[0]
                        : loc.noDateSelected,
                  ),
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
                          if (!_readed) {
                            _rating = 0;
                            _finishedDate = null;
                          }
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
                  subtitle: Text(
                    _finishedDate != null
                        ? _finishedDate!.toLocal().toString().split(' ')[0]
                        : loc.noDateSelected,
                  ),
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
                const SizedBox(height: 20),
                TextField(
                  controller: _isbnController,
                  decoration: InputDecoration(labelText: loc.isbn13Label),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Text(loc.borrowed),
                    const Spacer(),
                    Switch(
                      value: _borrowed,
                      onChanged: (val) {
                        setState(() {
                          _borrowed = val;
                          if (_borrowed) {
                            _borrowedDate = DateTime.now();
                          } else {
                            _borrowedByController.text = '';
                            _borrowedDate = null;
                          }
                        });
                      },
                    ),
                  ],
                ),
                if (_borrowed) ...[
                  const SizedBox(height: 10),
                  TextField(
                    controller: _borrowedByController,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                      labelText: loc.borrowedBy,
                      helperText: _borrowedDate != null
                          ? '${loc.borrowedSince} ${_borrowedDate!.toLocal().toString().split(' ')[0]}'
                          : null,
                    ),
                  ),
                ],
                const SizedBox(height: 32),
                // TextField(
                //   controller: _notesController,
                //   maxLines: 10,
                //   decoration: InputDecoration(labelText: 'notes'),
                // ),
                Scrollbar(
                  child: SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxHeight:
                            300, // Adjust based on your needs (e.g., 5 lines * line height)
                      ),
                      child: TextField(
                        controller: _notesController,
                        maxLines: 10, // Allows up to 10 lines
                        decoration: InputDecoration(
                          labelText: loc.notes,
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ),
                ),
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
                if (_titleController.text.trim().isEmpty ||
                    _authorController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(loc.warningTitleAuthorNotEmpty),
                      duration: Durations.medium2,
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }
                if (!_validateSave()) {
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
