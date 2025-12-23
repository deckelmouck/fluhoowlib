import 'package:flutter/material.dart';
import 'package:hoowlib/models/book.dart';


class BookMenuSheet extends StatelessWidget {
  final Book book;

  const BookMenuSheet({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  book.title, 
                  style: Theme.of(context).textTheme.headlineSmall,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ]
          ),
          Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: TextButton.icon(
                  onPressed: () {}, 
                  label: const Text('mark as readed'), 
                  icon: const Icon(Icons.book),
                ),
              ),
            ],
          ),
          SizedBox(height: 8,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: TextButton.icon(
                  onPressed: () {}, 
                  label: const Text('edit'), 
                  icon: const Icon(Icons.edit),
                ),
              ),
            ],
          ),
          SizedBox(height: 8,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: TextButton.icon(
                  onPressed: () {}, 
                  label: const Text('delete'), 
                  icon: const Icon(Icons.delete),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}