import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/finance_entry.dart';
import '../models/habit.dart';

class StorageService {
  static final String _financeKey = 'finance_entries';
  static final String _habitsKey = 'habits';
  static final String _budgetKey = 'monthly_budget';
  static final String _settingsKey = 'app_settings';
  
  static SharedPreferences? _prefs;
  
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }
  
  static Future<SharedPreferences> get prefs async {
    return _prefs ??= await SharedPreferences.getInstance();
  }

  // Finance Methods
  static Future<void> saveFinanceEntries(List<FinanceEntry> entries) async {
    final preferences = await prefs;
    final entriesJson = entries.map((e) => jsonEncode(e.toJson())).toList();
    await preferences.setStringList(_financeKey, entriesJson);
  }
  
  static Future<List<FinanceEntry>> loadFinanceEntries() async {
    final preferences = await prefs;
    final entriesJson = preferences.getStringList(_financeKey) ?? [];
    return entriesJson
        .map((json) => FinanceEntry.fromJson(jsonDecode(json)))
        .toList();
  }

  // Habits Methods
  static Future<void> saveHabits(List<Habit> habits) async {
    final preferences = await prefs;
    final habitsJson = habits.map((h) => jsonEncode(h.toJson())).toList();
    await preferences.setStringList(_habitsKey, habitsJson);
  }

  static Future<List<Habit>> loadHabits() async {
    final preferences = await prefs;
    final habitsJson = preferences.getStringList(_habitsKey) ?? [];
    return habitsJson
        .map((json) => Habit.fromJson(jsonDecode(json)))
        .toList();
  }

  // Settings Methods
  static Future<void> saveSettings(Map<String, dynamic> settings) async {
    final preferences = await prefs;
    await preferences.setString(_settingsKey, jsonEncode(settings));
  }

  static Future<Map<String, dynamic>> loadSettings() async {
    final preferences = await prefs;
    final settingsJson = preferences.getString(_settingsKey);
    if (settingsJson == null) {
      return {
        'isDarkMode': false,
        'notificationsEnabled': true,
        'reminderTime': '20:00',
        'language': 'id',
      };
    }
    return Map<String, dynamic>.from(jsonDecode(settingsJson));
  }

  static Future<void> clearAllData() async {
    final preferences = await prefs;
    await preferences.clear();
  }
} 