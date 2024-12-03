class Habit {
  final String id;
  final String name;
  final String frequency;
  final List<DateTime> completedDates;
  final DateTime? reminderTime;

  Habit({
    required this.id,
    required this.name,
    required this.frequency,
    required this.completedDates,
    this.reminderTime,
  });

  factory Habit.fromJson(Map<String, dynamic> json) {
    return Habit(
      id: json['id'],
      name: json['name'],
      frequency: json['frequency'],
      completedDates: json['completedDates'] ?? [],
      reminderTime: json['reminderTime'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'frequency': frequency,
      'completedDates': completedDates,
      'reminderTime': reminderTime,
    };
  }

  bool get isCompleted {
    final today = DateTime.now();
    return completedDates.any((date) => 
      date.year == today.year && 
      date.month == today.month && 
      date.day == today.day
    );
  }

  bool isCompletedForToday() {
    final today = DateTime.now();
    return completedDates.any((date) =>
        date.year == today.year &&
        date.month == today.month &&
        date.day == today.day);
  }
} 