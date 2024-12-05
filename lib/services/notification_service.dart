import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import '../firebase_options.dart';

class NotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  static Future<void> initialize() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // Meminta izin notifikasi
    NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Mengatur handler untuk pesan foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Pesan diterima saat foreground: ${message.notification?.title}');
      // Di sini Anda bisa menampilkan dialog atau snackbar
    });

    // Mengatur handler untuk pesan background
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Mendapatkan token FCM
    String? token = await FirebaseMessaging.instance.getToken();
    print('Token FCM: $token');
  }

  // Handler untuk pesan background
  static Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('Pesan diterima saat background: ${message.notification?.title}');
  }

  // Metode untuk mengirim notifikasi budget (implementasi server-side diperlukan)
  static Future<void> showBudgetAlert({
    required double currentSpending,
    required double budget,
  }) async {
    print('Budget Alert: $currentSpending / $budget');
    // Implementasi pengiriman notifikasi melalui Firebase Cloud Functions atau backend Anda
  }

  Future<bool> requestPermission() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission();
    return settings.authorizationStatus == AuthorizationStatus.authorized;
  }
} 