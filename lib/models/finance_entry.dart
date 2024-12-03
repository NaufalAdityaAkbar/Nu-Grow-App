class FinanceEntry {
  final String id;
  final double amount;
  final String category;
  final DateTime date;
  final bool isIncome;

  FinanceEntry({
    required this.id,
    required this.amount,
    required this.category,
    required this.date,
    required this.isIncome,
  });

  factory FinanceEntry.fromJson(Map<String, dynamic> json) {
    return FinanceEntry(
      id: json['id'],
      amount: json['amount'],
      category: json['category'],
      date: DateTime.parse(json['date']),
      isIncome: json['isIncome'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'category': category,
      'date': date.toIso8601String(),
      'isIncome': isIncome,
    };
  }
} 