import 'package:flutter/material.dart';
import 'package:interviya/data/models/user_model.dart';
import 'package:interviya/data/services/auth_service.dart';

class UserProvider extends ChangeNotifier {
  UserModel? _currentUser;
  bool _isLoading = true;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isAdmin => _currentUser?.isAdmin ?? false;

  // Fetch data once on app start or login
  Future<void> fetchUser() async {
    _isLoading = true;
    notifyListeners();

    _currentUser = await AuthService().getUserData();
    
    _isLoading = false;
    notifyListeners();
  }

  // Call this when the user logs out
  void clearUser() {
    _currentUser = null;
    notifyListeners();
  }
}