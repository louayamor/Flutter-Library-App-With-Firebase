import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/user_service.dart';

class UserController with ChangeNotifier {
  final UserService _userService = UserService();

  AppUser? _currentUser;
  AppUser? get currentUser => _currentUser;

  List<AppUser> _users = [];
  List<AppUser> get users => _users;

  Future<void> loadUser(String userId) async {
    _currentUser = await _userService.getUser(userId);
    notifyListeners();
  }

  Future<void> addUser(AppUser user) async {
    await _userService.createUser(user);
    _users.add(user);
    notifyListeners();
  }

  Future<void> updateUser(AppUser user) async {
    await _userService.updateUser(user);
    final index = _users.indexWhere((u) => u.id == user.id);
    if (index != -1) _users[index] = user;
    notifyListeners();
  }

  Future<void> loadAllUsers() async {
    _users = await _userService.getAllUsers();
    notifyListeners();
  }
}
