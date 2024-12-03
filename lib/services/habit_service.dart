import '../models/habit.dart';
import '../services/api_service.dart';

class HabitService {
  final ApiService _apiService;

  HabitService(this._apiService);

  Future<List<Habit>> getHabits() async {
    // Return data dummy
    return [
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
      Habit(
        id: '3',
        name: 'Meditasi',
        frequency: 'Harian',
        completedDates: [],
      ),
    ];
  }

  Future<void> createHabit(Habit habit) async {
    // Simulasi delay network
    await Future.delayed(const Duration(milliseconds: 500));
  }

  Future<void> updateHabit(String id, Habit habit) async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  Future<void> deleteHabit(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  Future<void> toggleHabitCompletion(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
  }
}