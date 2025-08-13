import 'package:flutter/material.dart';
import 'package:hoowlib/models/book.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Book'),
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
                decoration: InputDecoration(labelText: 'Title'),
                onSaved: (value) => _title = value ?? '',
                validator: (value) => value!.isEmpty ? 'Enter title' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Author'),
                onSaved: (value) => _author = value ?? '',
                validator: (value) => value!.isEmpty ? 'Enter author' : null,
              ),
              Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    child: Text('Cancel'),
                    onPressed: () => Navigator.pop(context),
                  ),
                  ElevatedButton(
                    child: Text('Save'),
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