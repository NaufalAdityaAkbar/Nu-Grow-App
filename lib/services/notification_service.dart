import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/foundation.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter/material.dart';
import '../models/habit.dart';
import '../services/api_service.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = 
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    // Implementasi sederhana untuk sementara
    print('Notification Service Initialized');
  }
  
  static Future<void> showBudgetAlert({
    required double currentSpending,
    required double budget,
  }) async {
    print('Budget Alert: $currentSpending / $budget');
  }

  Future<bool> requestPermission() async {
    final settings = await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestPermission();
    return settings ?? false;
  }
} 