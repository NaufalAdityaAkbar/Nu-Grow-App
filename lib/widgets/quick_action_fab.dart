import 'package:flutter/material.dart';
import '../screens/add_habit_screen.dart';
import '../screens/add_transaction_screen.dart';
import '../theme/app_theme.dart';
class QuickActionFAB extends StatefulWidget {
  const QuickActionFAB({super.key});

  @override
  State<QuickActionFAB> createState() => _QuickActionFABState();
}

class _QuickActionFABState extends State<QuickActionFAB>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotateAnimation;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
        reverseCurve: Curves.easeIn,
      ),
    );

    _rotateAnimation = Tween<double>(begin: 0.0, end: 0.5).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
        reverseCurve: Curves.easeIn,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        // Background overlay
        if (_isExpanded)
          GestureDetector(
            onTap: _toggleMenu,
            child: Container(
              color: const Color.fromARGB(0, 0, 0, 0),
              width: double.infinity,
              height: double.infinity,
            ),
          ),

        // FAB Menu Items
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            ScaleTransition(
              scale: _scaleAnimation,
              child: _buildFabMenuItem(
                icon: Icons.add_task,
                label: 'Tambah Kebiasaan',
                onTap: () {
                  _toggleMenu();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddHabitScreen(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            ScaleTransition(
              scale: _scaleAnimation,
              child: _buildFabMenuItem(
                icon: Icons.add_card,
                label: 'Tambah Transaksi',
                onTap: () {
                  _toggleMenu();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddTransactionScreen(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            FloatingActionButton(
              onPressed: _toggleMenu,
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: theme.colorScheme.onPrimary,
              child: RotationTransition(
                turns: _rotateAnimation,
                child: const Icon(Icons.add),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFabMenuItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Material(
          color: theme.colorScheme.surface,
          elevation: 4,
          borderRadius: BorderRadius.circular(24),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(24),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              child: Row(
                children: [
                  Icon(
                    icon, 
                    color: theme.colorScheme.primary,
                    size: 20
                  ),
                  const SizedBox(width: 8),
                  Text(
                    label,
                    style: TextStyle(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _toggleMenu() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
} 