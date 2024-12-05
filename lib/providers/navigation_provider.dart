import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NavigationProvider extends ChangeNotifier {
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  void setIndex(int index) {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && user.emailVerified) {
      if (index != _currentIndex && index >= 0 && index <= 3) {
        _currentIndex = index;
        notifyListeners();
      }
    }
  }
} 