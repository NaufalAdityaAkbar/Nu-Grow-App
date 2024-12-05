import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';

// Tambahkan enum untuk tipe auth
enum AuthType {
  email,
  google
}

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Key untuk SharedPreferences
  static const String userKey = 'user_logged_in';
  static const String tempEmailKey = 'temp_email';
  static const String tempPasswordKey = 'temp_password';

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
  Future<(bool, String)> signInWithEmailPassword(String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user != null) {
        if (!user.emailVerified) {
          // Simpan kredensial untuk verifikasi
          await saveTempCredentials(email, password);
          await user.sendEmailVerification();
          return (false, 'need_verification');
        }
        
        await saveLoginStatus(true);
        return (true, 'success');
      }
      return (false, 'login_failed');
    } catch (e) {
      if (e.toString().contains('user-not-found')) {
        // Jika email belum terdaftar, arahkan ke register
        await saveTempCredentials(email, password);
        return (false, 'register_first');
      } else if (e.toString().contains('wrong-password')) {
        return (false, 'wrong_password');
      }
      throw Exception(e.toString());
    }
  }

  // Register dengan email
  Future<(bool, String)> registerWithEmailPassword(String email, String password) async {
    try {
      // Cek apakah email sudah terdaftar
      final methods = await _auth.fetchSignInMethodsForEmail(email);
      if (methods.isNotEmpty) {
        return (false, 'email_exists');
      }

      // Buat user baru
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        // Kirim email verifikasi
        await userCredential.user!.sendEmailVerification();
        
        // Simpan kredensial untuk verifikasi otomatis
        await saveTempCredentials(email, password);
        
        print('Verification email sent to: ${userCredential.user!.email}');
        return (true, 'need_verification');
      }
      return (false, 'registration_failed');
    } on FirebaseAuthException catch (e) {
      print('Firebase Auth Error: ${e.code}');
      switch (e.code) {
        case 'email-already-in-use':
          return (false, 'email_exists');
        case 'weak-password':
          return (false, 'weak_password');
        case 'invalid-email':
          return (false, 'invalid_email');
        default:
          return (false, e.message ?? 'unknown_error');
      }
    } catch (e) {
      print('Registration Error: $e');
      return (false, 'registration_failed');
    }
  }

  // Login dengan Google
  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Langsung masuk tanpa verifikasi
      return await _auth.signInWithCredential(credential);
    } catch (e) {
      print('Error signing in with Google: $e');
      return null;
    }
  }

  // Logout untuk email/password
  Future<void> signOutEmail() async {
    await _auth.signOut();
    await saveLoginStatus(false);
  }

  // Logout untuk Google
  Future<void> signOutGoogle() async {
    await _auth.signOut();
    await GoogleSignIn().signOut();
    await saveLoginStatus(false);
  }

  // Logout umum - gunakan ini untuk tombol logout di aplikasi
  Future<void> signOut() async {
    await clearTempCredentials();
    try {
      await GoogleSignIn().signOut();
    } catch (e) {
      // Abaikan error jika bukan login Google
    }
    await _auth.signOut();
    await saveLoginStatus(false);
  }

  // Kirim ulang email verifikasi
  Future<void> resendVerificationEmail() async {
    try {
      final user = _auth.currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
      }
    } catch (e) {
      throw Exception('Gagal mengirim email verifikasi: ${e.toString()}');
    }
  }

  // Mendengarkan perubahan status verifikasi email
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Cek status verifikasi email
  Future<bool> checkEmailVerified() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await user.reload();
        // Dapatkan user yang sudah di-reload
        final refreshedUser = _auth.currentUser;
        print('Email verified status: ${refreshedUser?.emailVerified}');
        return refreshedUser?.emailVerified ?? false;
      }
      return false;
    } catch (e) {
      print('Error checking email verification: $e');
      return false;
    }
  }

  // Cek status verifikasi email dengan sign in ulang
  Future<bool> reloadAndCheckVerification() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        // Reload user data dari Firebase
        await user.reload();
        
        // Dapatkan user yang sudah di-reload
        final freshUser = _auth.currentUser;
        final isVerified = freshUser?.emailVerified ?? false;
        
        print('Checking verification for email: ${freshUser?.email}');
        print('Verification status: $isVerified');
        
        if (isVerified) {
          await saveLoginStatus(true);
          print('User verified successfully');
          return true;
        }
      } else {
        // Jika tidak ada user yang login, coba sign in ulang
        if (_lastEmail != null && _lastPassword != null) {
          try {
            final userCredential = await _auth.signInWithEmailAndPassword(
              email: _lastEmail!,
              password: _lastPassword!,
            );
            
            final verifiedUser = userCredential.user;
            if (verifiedUser != null && verifiedUser.emailVerified) {
              await saveLoginStatus(true);
              return true;
            }
          } catch (e) {
            print('Error signing in: $e');
          }
        }
      }
      
      return false;
    } catch (e) {
      print('Error in verification check: $e');
      return false;
    }
  }

  // Tambahkan method baru untuk memeriksa status verifikasi
  Future<bool> checkVerificationStatus() async {
    try {
      // Ambil credentials yang tersimpan
      final prefs = await SharedPreferences.getInstance();
      final email = prefs.getString(tempEmailKey);
      final password = prefs.getString(tempPasswordKey);

      if (email != null && password != null) {
        try {
          // Coba sign in dengan credentials yang tersimpan
          final userCredential = await _auth.signInWithEmailAndPassword(
            email: email,
            password: password,
          );

          final user = userCredential.user;
          if (user != null) {
            await user.reload();
            final isVerified = user.emailVerified;
            
            print('Checking verification for email: ${user.email}');
            print('Verification status: $isVerified');

            if (isVerified) {
              // Hapus credentials sementara
              await prefs.remove(tempEmailKey);
              await prefs.remove(tempPasswordKey);
              // Simpan status login
              await saveLoginStatus(true);
              return true;
            }
          }
        } catch (e) {
          print('Error signing in during verification check: $e');
        }
      }
      return false;
    } catch (e) {
      print('Error checking verification status: $e');
      return false;
    }
  }

  // Method untuk memperbarui status verifikasi
  Future<void> updateVerificationStatus() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await user.reload();
        final isVerified = user.emailVerified;
        if (isVerified) {
          await saveLoginStatus(true);
          print('User verification status updated: verified');
        }
      }
    } catch (e) {
      print('Error updating verification status: $e');
    }
  }

  // Dapatkan email user saat ini
  String? getCurrentUserEmail() {
    return _auth.currentUser?.email;
  }

  // Sign in kembali untuk verifikasi
  Future<bool> reSignInForVerification() async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: _lastEmail!, 
        password: _lastPassword!,
      );
      return userCredential.user?.emailVerified ?? false;
    } catch (e) {
      print('Error re-signing in: $e');
      return false;
    }
  }

  Future<void> sendEmailVerification() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
    }
  }

  // Tambahkan fungsi untuk memastikan verifikasi email
  Future<bool> isEmailVerified() async {
    final user = _auth.currentUser;
    if (user != null) {
      await user.reload();
      return user.emailVerified;
    }
    return false;
  }

  // Simpan credentials untuk re-authentication
  String? _lastEmail;
  String? _lastPassword;
  AuthType? _lastAuthType;

  void setCredentials(String email, String password) {
    _lastEmail = email;
    _lastPassword = password;
    print('Credentials saved for re-authentication');
  }

  // Method untuk membersihkan credentials sementara
  Future<void> clearTempCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(tempEmailKey);
    await prefs.remove(tempPasswordKey);
  }

  // Simpan kredensial sementara
  Future<void> saveTempCredentials(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(tempEmailKey, email);
    await prefs.setString(tempPasswordKey, password);
  }

  // Cek dan masuk otomatis setelah verifikasi
  Future<bool> checkAndSignInAfterVerification() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final email = prefs.getString(tempEmailKey);
      final password = prefs.getString(tempPasswordKey);

      if (email != null && password != null) {
        final userCredential = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        final user = userCredential.user;
        if (user != null) {
          await user.reload();
          final isVerified = user.emailVerified;

          if (isVerified) {
            await saveLoginStatus(true);
            await clearTempCredentials();
            return true;
          }
        }
      }
      return false;
    } catch (e) {
      print('Error during sign-in after verification: $e');
      return false;
    }
  }
}
