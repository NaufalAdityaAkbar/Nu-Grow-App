import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/finance_entry.dart';
import '../models/habit.dart';
import '../models/finance_category.dart';
import '../models/habit.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:5000/api';
  
  Future<Map<String, String>> _getHeaders() async {
    return {
      'Content-Type': 'application/json',
    };
  }

  Future<dynamic> get(String endpoint) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [];
  }

  Future<dynamic> post(String endpoint, Map<String, dynamic> data) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return {'success': true};
  }

  Future<dynamic> put(String endpoint, Map<String, dynamic> data) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return {'success': true};
  }

  Future<dynamic> delete(String endpoint) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return {'success': true};
  }
}