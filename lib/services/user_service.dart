import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user.dart';

class UserService {
  final CollectionReference _usersRef =
      FirebaseFirestore.instance.collection('users');

  Future<AppUser?> getUser(String userId) async {
    final doc = await _usersRef.doc(userId).get();
    if (!doc.exists) return null;
    return AppUser.fromMap(doc.data() as Map<String, dynamic>, doc.id);
  }

  Future<void> createUser(AppUser user) async {
    await _usersRef.doc(user.id).set(user.toMap());
  }

  Future<void> updateUser(AppUser user) async {
    await _usersRef.doc(user.id).update(user.toMap());
  }

  Future<List<AppUser>> getAllUsers() async {
    final snapshot = await _usersRef.get();
    return snapshot.docs
        .map((doc) => AppUser.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  }
}
