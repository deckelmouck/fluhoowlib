import 'package:flutter/material.dart';
import 'package:hoowlib/db/database_helper.dart';
import 'package:hoowlib/models/book.dart';
import 'package:hoowlib/models/book_order_by.dart';

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
      Book? newItem = await DatabaseHelper().getBookById(added);
      if (newItem != null) {
        _books.add(newItem);
      }
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

  Future updateBook(Book updateBook) async {
    int updated = await DatabaseHelper().updateBook(updateBook);
    if (updated > 0) {
      _fetchBooksFromDatabase();
    }
  }

  Future markAsRead(Book readedBook) async {
    final updatedBook = Book(
      id: readedBook.id,
      title: readedBook.title,
      author: readedBook.author,
      readed: true,
      rating: 0,
      publicationDate: readedBook.publicationDate,
      finishedDate: DateTime.now(),
    );
    await updateBook(updatedBook);
  }

  Future<void> _fetchBooksFromDatabase() async {
    final booksFromDb = await DatabaseHelper().getBooks();
    _books = booksFromDb;
    notifyListeners();
  }

  void sortBooks(BookOrderBy orderBy) {
    if (orderBy == BookOrderBy.id) {
      books.sort((a, b) => (a.id ?? 0).compareTo(b.id ?? 0));
    } else if (orderBy == BookOrderBy.title) {
      books.sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
    } else if (orderBy == BookOrderBy.author) {
      books.sort((a, b) => a.author.compareTo(b.author));
    } else if (orderBy == BookOrderBy.rating) {
      books.sort((a, b) => b.rating.compareTo(a.rating));
    } else if (orderBy == BookOrderBy.publication) {
      books.sort((a, b) => b.publicationDate?.compareTo(a.publicationDate ?? DateTime(0)) ?? 0);
    }
    notifyListeners();
  }
}