class AuthService {
  bool _isLoggedIn = false;

  // Login dengan email & password
  Future<bool> signInWithEmailPassword(String email, String password) async {
    // Simulasi delay network
    await Future.delayed(const Duration(seconds: 1));
    _isLoggedIn = true;
    return true;
  }

  // Register dengan email & password
  Future<bool> registerWithEmailPassword(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    _isLoggedIn = true;
    return true;
  }

  // Login dengan Google
  Future<bool> signInWithGoogle() async {
    await Future.delayed(const Duration(seconds: 1));
    _isLoggedIn = true;
    return true;
  }

  // Logout
  Future<void> signOut() async {
    _isLoggedIn = false;
  }

  // Get current user
  bool get isLoggedIn => _isLoggedIn;

  // Stream untuk memantau status autentikasi
  Stream<bool> get authStateChanges => Stream.value(_isLoggedIn);
}