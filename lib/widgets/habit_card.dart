import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/habit_provider.dart';
import '../models/habit.dart';

class HabitCard extends StatelessWidget {
  final Habit habit;

  const HabitCard({
    required this.habit,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      child: ListTile(
        leading: Icon(
          Icons.check_circle_outline,
          color: theme.colorScheme.primary,
        ),
        title: Text(habit.name),
        subtitle: Text(habit.frequency),
        trailing: Switch(
          value: habit.isCompleted,
          activeColor: theme.colorScheme.primary,
          onChanged: (bool value) {
            context.read<HabitProvider>().toggleHabitCompletion(habit.id);
          },
        ),
      ),
    );
  }
} 