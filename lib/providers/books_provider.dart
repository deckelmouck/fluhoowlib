import 'package:flutter/material.dart';
import 'package:hoowlib/db/database_helper.dart';
import 'package:hoowlib/models/book.dart';
import 'package:hoowlib/repositories/book_repository.dart';

class BooksProvider extends ChangeNotifier {
  List<Book> _books = [];

  BooksProvider() {
    _fetchBooksFromDatabase();
  }
  
  int get count => _books.length;

  List<Book> get books => _books;

  void setBooks(List<Book> newBooks)
  {
    _books = newBooks;
    notifyListeners();
  }

  Future addBook(Book newBook) async {
    int added = await DatabaseHelper().insertBook(newBook);
    
    if (added > 0) {
      _books.add(newBook);
      notifyListeners();
    }
  }

  Future<void> deleteBook(Book book) async {
    int deleted = await DatabaseHelper().deleteBook(book.id!);
    if (deleted > 0) {
      _books.removeWhere((b) => b.id == book.id);
      notifyListeners();
    }
  }

  Future<void> _fetchBooksFromDatabase() async {
    final booksFromDb = await DatabaseHelper().getBooks();
    _books = booksFromDb;
    notifyListeners();
  }
}