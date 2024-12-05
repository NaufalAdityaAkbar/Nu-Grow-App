import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'dart:async';
import '../services/auth_service.dart';
import '../main.dart';

class VerificationDialog extends StatefulWidget {
  final VoidCallback onResendEmail;
  final String email;

  const VerificationDialog({
    super.key,
    required this.onResendEmail,
    required this.email,
  });

  @override
  State<VerificationDialog> createState() => _VerificationDialogState();
}

class _VerificationDialogState extends State<VerificationDialog> {
  Timer? _verificationTimer;
  final AuthService _authService = AuthService();
  bool _isChecking = false;
  int _retryCount = 0;
  static const int maxRetries = 30; // Maximum 1.5 menit (30 x 3 detik)

  Future<void> _checkVerification() async {
    if (_isChecking) return;

    _isChecking = true;
    try {
      print('Checking verification attempt $_retryCount...');

      await _authService.reSignInForVerification();
      final isVerified = await _authService.checkEmailVerified();

      if (isVerified && mounted) {
        print('Verification successful!');
        _verificationTimer?.cancel();

        if (mounted) {
          Navigator.of(context).pop();
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (context) => const MainNavigationScreen()),
            (route) => false,
          );
        }
      } else {
        _retryCount++;
        print('Not verified yet. Attempt: $_retryCount');

        if (_retryCount >= maxRetries) {
          print('Max verification attempts reached');
          _verificationTimer?.cancel();
          await _authService.clearTempCredentials();
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content:
                    Text('Waktu verifikasi habis. Silakan coba login kembali.'),
                backgroundColor: Colors.orange,
              ),
            );
            Navigator.of(context).pop();
          }
        }
      }
    } finally {
      _isChecking = false;
    }
  }

  @override
  void initState() {
    super.initState();
    print('Starting verification checks...');

    // Tunggu sebentar sebelum pengecekan pertama
    Future.delayed(const Duration(seconds: 2), () {
      // Cek setiap 3 detik
      _verificationTimer = Timer.periodic(
        const Duration(seconds: 3),
        (_) => _checkVerification(),
      );
      // Cek pertama kali
      _checkVerification();
    });
  }

  @override
  void dispose() {
    _verificationTimer?.cancel();
    _authService.clearTempCredentials();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return PopScope(
      canPop: false,
      child: Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.network(
                'https://lottie.host/bf704ed2-2b48-4b94-b20a-1d1014ebbad0/NSzMAGHoQ0.json',
                width: size.width * 0.8,
                repeat: true,
                frameRate: FrameRate(60),
              ),
              const SizedBox(height: 24),
              Text(
                'Verifikasi Email',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Kami telah mengirim email verifikasi ke:\n${widget.email}\n\nSilakan cek kotak masuk atau folder spam.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.timer, color: Colors.grey[600], size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Belum menerima email?',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              TextButton.icon(
                onPressed: () {
                  widget.onResendEmail();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Email verifikasi telah dikirim ulang'),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Kirim Ulang Email'),
                style: TextButton.styleFrom(
                  foregroundColor: theme.colorScheme.primary,
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
