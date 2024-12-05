import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import '../screens/login_screen.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  bool _isAuthenticated = false;
  User? _user;
  bool _isVerified = false;

  bool get isAuthenticated => _isAuthenticated;
  bool get isVerified => _isVerified;
  User? get user => _user;

  AuthProvider() {
    _initializeAuth();
  }

  Future<void> _initializeAuth() async {
    FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      if (user != null) {
        await user.reload();
        final updatedUser = FirebaseAuth.instance.currentUser;
        
        _user = updatedUser;
        _isAuthenticated = updatedUser != null;
        _isVerified = updatedUser?.emailVerified ?? false;
        
        if (_isAuthenticated && !_isVerified) {
          _startVerificationCheck();
        }
      } else {
        _user = null;
        _isAuthenticated = false;
        _isVerified = false;
      }
      notifyListeners();
    });
  }

  Timer? _verificationTimer;

  void _startVerificationCheck() {
    _verificationTimer?.cancel();
    _verificationTimer = Timer.periodic(const Duration(seconds: 3), (timer) async {
      final isVerified = await checkEmailVerification();
      if (isVerified) {
        timer.cancel();
        _isVerified = true;
        notifyListeners();
      }
    });
  }

  Future<bool> checkEmailVerification() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.reload();
        return user.emailVerified;
      }
      return false;
    } catch (e) {
      print('Error checking verification: $e');
      return false;
    }
  }

  @override
  void dispose() {
    _verificationTimer?.cancel();
    super.dispose();
  }

  Future<void> signOut() async {
    await _authService.signOut();
    _isAuthenticated = false;
    _isVerified = false;
    _user = null;
    notifyListeners();
  }

  void navigateToLogin(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }
} 