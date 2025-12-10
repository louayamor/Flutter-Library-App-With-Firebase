import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../services/auth_service.dart';
import '../models/user.dart'; // AppUser

class AuthController with ChangeNotifier {
  final AuthService _authService = AuthService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? _user;
  User? get user => _user;

  AppUser? _appUser;
  AppUser? get appUser => _appUser;

  AuthController() {
    _authService.userStream.listen((u) async {
      _user = u;
      notifyListeners();

      if (_user != null) {
        final doc =
            await _firestore.collection('users').doc(_user!.uid).get();

        if (doc.exists) {
          setUserFromMap(doc.data()!, doc.id);
        }
      } else {
        _appUser = null;
        notifyListeners();
      }
    });
  }

  void setUserFromMap(Map<String, dynamic> data, String id) {
    _appUser = AppUser(
      id: id,
      name: data['name'] ?? "",
      email: data['email'] ?? "",
      role: data['role'] ?? "user",
      borrowedBooks: [], 
    );

    notifyListeners();
  }

  Future<void> register(String email, String password) async {
    await _authService.register(email, password);
  }

  Future<void> login(String email, String password) async {
    await _authService.login(email, password);
  }

  Future<void> logout() async {
    await _authService.logout();
  }
}
