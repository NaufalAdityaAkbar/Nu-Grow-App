import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  // Key untuk SharedPreferences
  static const String userKey = 'user_logged_in';

  // Cek status login
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(userKey) ?? false;
  }

  // Simpan status login
  Future<void> saveLoginStatus(bool status) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(userKey, status);
  }

  // Login dengan email & password
  Future<bool> signInWithEmailPassword(String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCredential.user != null) {
        await saveLoginStatus(true);
        return true;
      }
      return false;
    } catch (e) {
      throw Exception('Gagal masuk: ${e.toString()}');
    }
  }

  // Register dengan email & password
  Future<bool> registerWithEmailPassword(String email, String password) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCredential.user != null) {
        await saveLoginStatus(true);
        return true;
      }
      return false;
    } catch (e) {
      throw Exception('Gagal mendaftar: ${e.toString()}');
    }
  }

  // Login dengan Google
  Future<bool> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return false;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      if (userCredential.user != null) {
        await saveLoginStatus(true);
        return true;
      }
      return false;
    } catch (e) {
      throw Exception('Gagal masuk dengan Google: ${e.toString()}');
    }
  }

  // Logout
  Future<void> signOut() async {
    await _auth.signOut();
    await GoogleSignIn().signOut();
    await saveLoginStatus(false);
  }
}