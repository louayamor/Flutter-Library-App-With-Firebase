import 'package:flutter/material.dart';
import '../models/book.dart';
import '../services/book_service.dart';

class BookController extends ChangeNotifier {
  final BookService _bookService = BookService();

  Stream<List<Book>> get allBooks => _bookService.getBooks();

  Future<void> addBook(Book book) async {
    await _bookService.addBook(book);
    notifyListeners();
  }

  Future<void> updateBook(Book book) async {
    await _bookService.updateBook(book);
    notifyListeners();
  }

  Future<void> deleteBook(String id) async {
    await _bookService.deleteBook(id);
    notifyListeners();
  }

  Future<Book?> getBook(String id) async {
    return _bookService.getBookById(id);
  }
}
