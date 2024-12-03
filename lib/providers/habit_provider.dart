import 'package:flutter/foundation.dart';
import '../models/habit.dart';
import '../services/habit_service.dart';

class HabitProvider extends ChangeNotifier {
  final HabitService _habitService;
  List<Habit> _habits = [];
  bool _isLoading = false;

  HabitProvider(this._habitService) {
    loadHabits();
  }

  List<Habit> get habits => _habits;
  bool get isLoading => _isLoading;

  Future<void> loadHabits() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Dummy data untuk sementara
      _habits = [
        Habit(
          id: '1',
          name: 'Olahraga Pagi',
          frequency: 'Harian',
          completedDates: [],
        ),
        Habit(
          id: '2',
          name: 'Membaca Buku',
          frequency: 'Harian',
          completedDates: [],
        ),
      ];
    } catch (e) {
      print('Error loading habits: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addHabit(Habit habit) async {
    _habits.add(habit);
    notifyListeners();
  }

  Future<void> toggleHabitCompletion(String habitId) async {
    final habitIndex = _habits.indexWhere((h) => h.id == habitId);
    if (habitIndex != -1) {
      final habit = _habits[habitIndex];
      if (habit.isCompleted) {
        habit.completedDates.remove(DateTime.now());
      } else {
        habit.completedDates.add(DateTime.now());
      }
      notifyListeners();
    }
  }

  int getCompletedHabitsCountForToday() {
    return habits.where((habit) => habit.isCompletedForToday()).length;
  }
} 