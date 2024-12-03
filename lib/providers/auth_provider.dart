import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  bool _isAuthenticated = false;

  bool get isAuthenticated => _isAuthenticated;

  AuthProvider() {
    _authService.authStateChanges.listen((bool isLoggedIn) {
      _isAuthenticated = isLoggedIn;
      notifyListeners();
    });
  }

  Future<void> signOut() async {
    await _authService.signOut();
    _isAuthenticated = false;
    notifyListeners();
  }
} 