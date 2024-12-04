import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  bool _isAuthenticated = false;
  User? _user;

  bool get isAuthenticated => _isAuthenticated;
  User? get user => _user;

  AuthProvider() {
    _initializeAuth();
  }

  Future<void> _initializeAuth() async {
    // Cek status login dari SharedPreferences
    _isAuthenticated = await _authService.isLoggedIn();
    
    // Listen ke perubahan status auth Firebase
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      _user = user;
      _isAuthenticated = user != null;
      notifyListeners();
    });
  }

  Future<void> signOut() async {
    await _authService.signOut();
    _isAuthenticated = false;
    _user = null;
    notifyListeners();
  }
} 