// This file defines the AuthProvider class, which manages user authentication state and interactions with the AuthRepository.

import 'package:dufil/data/repos/auth_repo.dart';
import 'package:flutter/foundation.dart';

class AuthProvider with ChangeNotifier {
  final AuthRepository _authRepository;

  bool _isLoading = false;

  AuthProvider(this._authRepository);

  bool get isLoading => _isLoading;

  // Method to handle user sign-up, given an email and password.
  Future<void> signUp({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _authRepository.signUp(
        email: email,
        password: password,
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Method to handle user sign-in, given an email and password.
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _authRepository.signIn(
        email: email,
        password: password,
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
