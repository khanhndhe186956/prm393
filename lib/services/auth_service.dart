import 'package:flutter/foundation.dart';

import '../models/app_user.dart';
import '../utils/app_messages.dart';
import '../utils/constants.dart';
import 'mock_data.dart';

class AuthService extends ChangeNotifier {
  AppUser? _currentUser;
  bool _isLoading = false;

  AppUser? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _currentUser != null;

  Future<String?> login({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    notifyListeners();

    await Future<void>.delayed(const Duration(milliseconds: 600));

    if (password != AppConstants.demoPassword) {
      _isLoading = false;
      notifyListeners();
      return AppMessages.invalidCredentials;
    }

    final user = MockData.users.cast<AppUser?>().firstWhere(
          (u) => u!.email.toLowerCase() == email.trim().toLowerCase(),
          orElse: () => null,
        );

    if (user == null) {
      _isLoading = false;
      notifyListeners();
      return AppMessages.invalidCredentials;
    }

    _currentUser = user;
    _isLoading = false;
    notifyListeners();
    return null;
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }

  void updateProfile(AppUser updatedUser) {
    _currentUser = updatedUser;
    final index = MockData.users.indexWhere((u) => u.id == updatedUser.id);
    if (index != -1) {
      MockData.users[index] = updatedUser;
    }
    notifyListeners();
  }
}
