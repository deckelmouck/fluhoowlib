import '../models/book.dart';
import '../db/database_helper.dart';

class BookRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<List<Book>> getAllBooks() async {
    return await _dbHelper.getBooks();
  }

  Future<Book?> getBookById(int id) async {
    return await _dbHelper.getBookById(id);
  }

  Future<int> addBook(Book book) async {
    return await _dbHelper.insertBook(book);
  }

  Future<int> updateBook(Book book) async {
    return await _dbHelper.updateBook(book);
  }

  Future<int> deleteBook(int id) async {
    return await _dbHelper.deleteBook(id);
  }
}
