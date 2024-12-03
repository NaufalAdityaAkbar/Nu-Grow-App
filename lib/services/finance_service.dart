import '../models/finance_entry.dart';
import '../models/finance_category.dart';
import '../services/api_service.dart';

class FinanceService {
  final ApiService _apiService;

  FinanceService(this._apiService);

  Future<List<FinanceEntry>> getFinances() async {
    return [
      FinanceEntry(
        id: '1',
        amount: 5000000,
        category: 'Gaji',
        date: DateTime.now(),
        isIncome: true,
      ),
      FinanceEntry(
        id: '2',
        amount: 1000000,
        category: 'Makan',
        date: DateTime.now(),
        isIncome: false,
      ),
    ];
  }

  Future<void> createFinance(FinanceEntry entry) async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  Future<Map<String, dynamic>> getFinanceStats() async {
    return {
      'totalIncome': 5000000,
      'totalExpense': 1500000,
      'balance': 3500000,
    };
  }

  Future<double> getMonthlyBudget() async {
    return 5000000;
  }

  Future<void> updateMonthlyBudget(double budget) async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  Future<List<FinanceCategory>> getCategories() async {
    return defaultCategories;
  }
} 