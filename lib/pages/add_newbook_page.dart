import 'package:flutter/material.dart';
import 'package:hoowlib/models/book.dart';
import '../l10n/app_localizations.dart';

class AddNewbookPage extends StatefulWidget{
  const AddNewbookPage({super.key});

  @override
  AddNewbookPageState createState() => AddNewbookPageState();
}

class AddNewbookPageState extends State<AddNewbookPage> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _author = '';
  DateTime? _publicationDate;
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
        title: Text(loc.addNewBook),
        leading: IconButton(icon: Icon(Icons.arrow_back),
        onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: loc.bookTitle),
                onSaved: (value) => _title = value ?? '',
                validator: (value) => value!.isEmpty ? 'Enter title' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(labelText: loc.author),
                onSaved: (value) => _author = value ?? '',
                validator: (value) => value!.isEmpty ? 'Enter author' : null,
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Text(loc.publicationDate),
                  Spacer(),
                  TextButton(
                          onPressed: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: _publicationDate ?? DateTime.now(),
                              firstDate: DateTime(1500),
                              lastDate: DateTime.now(),
                            );
                            if (picked != null) _onPublicationDateChanged(picked);
                          },
                          child: Text(_publicationDate != null
                              ? '${_publicationDate!.day}.${_publicationDate!.month}.${_publicationDate!.year}'
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
                    value: _readed,
                    onChanged: _onReadedChanged,
                  ),
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
                      max: 10,
                      divisions: 10,
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
                            if (picked != null) _onFinishedDateChanged(picked);
                          }
                        : null,
                    child: Text(_finishedDate != null
                        ? '${_finishedDate!.day}.${_finishedDate!.month}.${_finishedDate!.year}'
                        : loc.selectDate),
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
                        final book = Book(title: _title, author: _author,
                          readed: _readed, rating: _rating.round(), publicationDate: _publicationDate, finishedDate: _finishedDate);
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
    );
  }
}