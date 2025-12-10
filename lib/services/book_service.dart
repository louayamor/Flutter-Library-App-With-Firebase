import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/book.dart';

class BookService {
  final CollectionReference booksRef =
      FirebaseFirestore.instance.collection('books');

  Future<void> addBook(Book book) async {
    await booksRef.add(book.toMap());
  }

  Future<void> updateBook(Book book) async {
    await booksRef.doc(book.id).update(book.toMap());
  }

  Future<void> deleteBook(String id) async {
    await booksRef.doc(id).delete();
  }

  // Get all books as a stream
  Stream<List<Book>> getBooks() {
    return booksRef.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => Book.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    });
  }

  // Get single book
  Future<Book?> getBookById(String id) async {
    final doc = await booksRef.doc(id).get();
    if (!doc.exists) return null;
    return Book.fromMap(doc.data() as Map<String, dynamic>, doc.id);
  }
}
