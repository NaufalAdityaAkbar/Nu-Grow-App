import 'package:flutter/foundation.dart';
import '../models/finance_entry.dart';
import '../services/finance_service.dart';

class FinanceProvider extends ChangeNotifier {
  final FinanceService _financeService;
  List<FinanceEntry> _entries = [];
  double _monthlyBudget = 5000000;
  bool _isLoading = false;
  
  FinanceProvider(this._financeService) {
    loadData();
  }
  
  List<FinanceEntry> get entries => _entries;
  double get monthlyBudget => _monthlyBudget;
  bool get isLoading => _isLoading;
  
  double get totalIncome {
    return _entries
        .where((entry) => entry.isIncome)
        .fold(0, (sum, entry) => sum + entry.amount);
  }
  
  double get totalExpense {
    return _entries
        .where((entry) => !entry.isIncome)
        .fold(0, (sum, entry) => sum + entry.amount);
  }
  
  double get balance => totalIncome - totalExpense;
  
  Future<void> loadData() async {
    _isLoading = true;
    notifyListeners();
    
    // Menambahkan data dummy
    _entries = [
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
      FinanceEntry(
        id: '3',
        amount: 500000,
        category: 'Transport',
        date: DateTime.now(),
        isIncome: false,
      ),
    ];
    
    _isLoading = false;
    notifyListeners();
  }
  
  void addEntry(FinanceEntry entry) {
    _entries.add(entry);
    notifyListeners();
  }
  
  void updateBudget(double newBudget) {
    _monthlyBudget = newBudget;
    notifyListeners();
  }
  
  Map<String, double> getExpensesByCategory() {
    final map = <String, double>{};
    for (var entry in _entries.where((e) => !e.isIncome)) {
      map[entry.category] = (map[entry.category] ?? 0) + entry.amount;
    }
    return map;
  }
} 