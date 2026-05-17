import 'package:flutter/material.dart';
import 'package:interviya/data/models/user_model.dart';
import 'package:interviya/data/services/auth_service.dart';

class UserProvider extends ChangeNotifier {
  UserModel? _currentUser;
  bool _isLoading = false;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isAdmin => _currentUser?.isAdmin ?? false;
  
  bool get isAuthenticated => _currentUser != null;

  Future<void> fetchUser() async {
    _isLoading = true;
    notifyListeners();

    try {
      _currentUser = await AuthService().getUserData();
    } catch (e) {
      debugPrint("Error fetching user: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setUser(UserModel? user) {
    _currentUser = user;
    _isLoading = false;
    notifyListeners();
  }
  void updateProfileFields({
    String? fullName,
    String? currentStatus,
    String? targetRole,
    String? experienceLevel,
    String? mainGoal,
    String? avatarPath,
    bool? hasFinishedSetup,
  }) {
    if (_currentUser != null) {
      _currentUser = _currentUser!.copyWith(
        fullName: fullName ?? _currentUser!.fullName,
        currentStatus: currentStatus ?? _currentUser!.currentStatus,
        targetRole: targetRole ?? _currentUser!.targetRole,
        experienceLevel: experienceLevel ?? _currentUser!.experienceLevel,
        mainGoal: mainGoal ?? _currentUser!.mainGoal,
        avatarPath: avatarPath ?? _currentUser!.avatarPath,
        hasFinishedSetup: hasFinishedSetup ?? _currentUser!.hasFinishedSetup,
      );
      notifyListeners();
    }
  }

  void updateAvatar(String imageUrl) {
    if (_currentUser != null) {
      _currentUser = _currentUser!.copyWith(avatarPath: imageUrl);
      notifyListeners();
    }
  }

  void clearUser() {
    _currentUser = null;
    _isLoading = false;
    notifyListeners();
  }
}