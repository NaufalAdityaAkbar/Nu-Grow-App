import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'screens/dashboard_screen.dart';
import 'screens/finance_stats_screen.dart';
import 'screens/habit_tracker_screen.dart';
import 'screens/settings_screen.dart';
import 'providers/finance_provider.dart';
import 'providers/habit_provider.dart';
import 'theme/app_theme.dart';
import 'services/notification_service.dart';
import 'providers/theme_provider.dart';
import 'providers/navigation_provider.dart';
import 'screens/splash_screen.dart';
import 'services/api_service.dart';
import 'services/finance_service.dart';
import 'services/habit_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await initializeDateFormatting('id_ID', null);
  Intl.defaultLocale = 'id_ID';
  
  await NotificationService.initialize();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<FinanceProvider>(
          create: (_) => FinanceProvider(FinanceService(ApiService())),
        ),
        ChangeNotifierProvider<HabitProvider>(
          create: (_) => HabitProvider(HabitService(ApiService())),
        ),
        ChangeNotifierProvider<ThemeProvider>(
          create: (_) => ThemeProvider(),
        ),
        ChangeNotifierProvider<NavigationProvider>(
          create: (_) => NavigationProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'Finance & Habit Tracker',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          home: const SplashScreen(),
        );
      },
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  final List<Widget> _screens = const [
    DashboardScreen(),
    FinanceStatsScreen(),
    HabitTrackerScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<NavigationProvider>(
      builder: (context, navigationProvider, child) {
        return Scaffold(
          body: _screens[navigationProvider.currentIndex],
          bottomNavigationBar: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 15,
                  offset: const Offset(0, -3),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildNavButton(
                  icon: Icons.home_outlined,
                  selectedIcon: Icons.home_rounded,
                  label: 'Beranda',
                  isSelected: navigationProvider.currentIndex == 0,
                  onTap: () => navigationProvider.setIndex(0),
                ),
                _buildNavButton(
                  icon: Icons.analytics_outlined,
                  selectedIcon: Icons.analytics_rounded,
                  label: 'Statistik',
                  isSelected: navigationProvider.currentIndex == 1,
                  onTap: () => navigationProvider.setIndex(1),
                ),
                _buildNavButton(
                  icon: Icons.track_changes_outlined,
                  selectedIcon: Icons.track_changes_rounded,
                  label: 'Habits',
                  isSelected: navigationProvider.currentIndex == 2,
                  onTap: () => navigationProvider.setIndex(2),
                ),
                _buildNavButton(
                  icon: Icons.settings_outlined,
                  selectedIcon: Icons.settings_rounded,
                  label: 'Pengaturan',
                  isSelected: navigationProvider.currentIndex == 3,
                  onTap: () => navigationProvider.setIndex(3),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildNavButton({
    required IconData icon,
    required IconData selectedIcon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).primaryColor;
    final selectedColor = isDarkMode ? Colors.white : primaryColor;
    final unselectedColor = isDarkMode 
        ? Colors.white.withOpacity(0.7) 
        : Theme.of(context).iconTheme.color?.withOpacity(0.7);
    final selectedBgColor = isDarkMode 
        ? Colors.white.withOpacity(0.1) 
        : primaryColor.withOpacity(0.1);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: EdgeInsets.symmetric(
          horizontal: isSelected ? 16.0 : 12.0,
          vertical: 8.0,
        ),
        decoration: BoxDecoration(
          color: isSelected ? selectedBgColor : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Icon(
                    isSelected ? selectedIcon : icon,
                    color: isSelected ? selectedColor : unselectedColor,
                    size: isSelected ? 26 : 24,
                  ),
                ],
              ),
            ),
            if (isSelected) ...[
              const SizedBox(width: 8),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 300),
                style: TextStyle(
                  color: selectedColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
                child: Text(label),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
