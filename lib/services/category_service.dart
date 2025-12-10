import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/category.dart';

class CategoryService {
  final CollectionReference _categoriesCollection =
      FirebaseFirestore.instance.collection('categories');

  Stream<List<Category>> getCategories() {
    return _categoriesCollection.snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Category.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList());
  }

  Future<void> addCategory(Category category) async {
    await _categoriesCollection.add(category.toMap());
  }

  Future<void> deleteCategory(String id) async {
    await _categoriesCollection.doc(id).delete();
  }

  Future<void> updateCategory(Category category) async {
    await _categoriesCollection.doc(category.id).update(category.toMap());
  }
}
