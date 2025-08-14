import 'package:flutter/material.dart';
import 'package:hoowlib/models/book.dart';
import 'package:flutter/services.dart';
import '../l10n/app_localizations.dart';

class AddNewbookPage extends StatefulWidget{
  @override
  _AddNewbookPageState createState() => _AddNewbookPageState();
}

class _AddNewbookPageState extends State<AddNewbookPage> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _author = '';

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
              TextFormField(
                decoration: InputDecoration(labelText: loc.author),
                onSaved: (value) => _author = value ?? '',
                validator: (value) => value!.isEmpty ? 'Enter author' : null,
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
                          readed: false, rating: 0, publicationDate: null, finishedDate: null);
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