import 'package:flutter/material.dart';
import '../models/book.dart';

class BookEditPage extends StatelessWidget {
  final Book book;
  const BookEditPage({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Book'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Edit details for: ${book.title}', style: const TextStyle(fontSize: 18)),
            // TODO: Add form fields for editing book details
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // TODO: Save changes
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
