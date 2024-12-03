import 'package:flutter/material.dart';

enum TransactionType { income, expense }

class FinanceCategory {
  final String id;
  final String name;
  final String icon;
  
  FinanceCategory({
    required this.id,
    required this.name,
    required this.icon,
  });

  factory FinanceCategory.fromJson(Map<String, dynamic> json) {
    return FinanceCategory(
      id: json['id'],
      name: json['name'],
      icon: json['icon'],
    );
  }
}

final List<FinanceCategory> expenseCategories = [
  FinanceCategory(
    id: 'makan',
    name: 'Makan',
    icon: Icons.restaurant.codePoint.toString(),
  ),
  FinanceCategory(
    id: 'transport',
    name: 'Transport',
    icon: Icons.directions_car.codePoint.toString(),
  ),
  FinanceCategory(
    id: 'hiburan',
    name: 'Hiburan',
    icon: Icons.movie.codePoint.toString(),
  ),
  FinanceCategory(
    id: 'belanja',
    name: 'Belanja',
    icon: Icons.shopping_bag.codePoint.toString(),
  ),
  FinanceCategory(
    id: 'utilitas',
    name: 'Utilitas',
    icon: Icons.build.codePoint.toString(),
  ),
];

final List<FinanceCategory> incomeCategories = [
  FinanceCategory(
    id: 'gaji',
    name: 'Gaji',
    icon: Icons.account_balance_wallet.codePoint.toString(),
  ),
  FinanceCategory(
    id: 'bonus',
    name: 'Bonus',
    icon: Icons.card_giftcard.codePoint.toString(),
  ),
  FinanceCategory(
    id: 'investasi',
    name: 'Investasi',
    icon: Icons.trending_up.codePoint.toString(),
  ),
  FinanceCategory(
    id: 'bisnis',
    name: 'Bisnis',
    icon: Icons.store.codePoint.toString(),
  ),
  FinanceCategory(
    id: 'lainnya',
    name: 'Lainnya',
    icon: Icons.more_horiz.codePoint.toString(),
  ),
];

// Gabungkan kedua list untuk backward compatibility
final List<FinanceCategory> defaultCategories = [...expenseCategories, ...incomeCategories]; 