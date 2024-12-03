import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/finance_provider.dart';
import '../theme/app_theme.dart';
import '../services/notification_service.dart';
import '../providers/theme_provider.dart';
import 'package:intl/intl.dart';
import '../constants/app_constants.dart';
import '../providers/auth_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  TimeOfDay _reminderTime = const TimeOfDay(hour: 20, minute: 0);
  final _budgetController = TextEditingController();
  bool _notificationsEnabled = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    // Load dari SharedPreferences nanti
    setState(() {
      _notificationsEnabled = true;
      _reminderTime = const TimeOfDay(hour: 20, minute: 0);
    });
  }

  Future<void> _handleLogout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Logout'),
        content: const Text('Apakah Anda yakin ingin keluar?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await context.read<AuthProvider>().signOut();
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    }
  }

  Future<void> _toggleNotifications(bool value) async {
    final notificationService = NotificationService();
    if (value) {
      await notificationService.requestPermission();
    }
    setState(() {
      _notificationsEnabled = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.primary,
                    theme.colorScheme.secondary,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(32),
                ),
              ),
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Pengaturan',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Sesuaikan aplikasi sesuai kebutuhan Anda',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildSettingsSection(
                  'Tampilan',
                  [
                    Consumer<ThemeProvider>(
                      builder: (context, themeProvider, child) {
                        return _buildSettingsCard(
                          icon: Icons.dark_mode,
                          title: 'Mode Gelap',
                          subtitle: 'Aktifkan tema gelap',
                          trailing: Switch(
                            value: themeProvider.isDarkMode,
                            onChanged: (value) => themeProvider.toggleTheme(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _buildSettingsSection(
                  'Notifikasi',
                  [
                    _buildSettingsCard(
                      icon: Icons.notifications,
                      title: 'Aktifkan Notifikasi',
                      subtitle: 'Terima pengingat dan peringatan',
                      trailing: Switch(
                        value: _notificationsEnabled,
                        onChanged: (value) async {
                          await _toggleNotifications(value);
                        },
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildSettingsCard(
                      icon: Icons.access_time,
                      title: 'Waktu Pengingat',
                      subtitle: _reminderTime.format(context),
                      onTap: () async {
                        final TimeOfDay? picked = await showTimePicker(
                          context: context,
                          initialTime: _reminderTime,
                        );
                        if (picked != null) {
                          setState(() {
                            _reminderTime = picked;
                          });
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _buildSettingsSection(
                  'Keuangan',
                  [
                    Consumer<FinanceProvider>(
                      builder: (context, provider, child) {
                        return _buildSettingsCard(
                          icon: Icons.account_balance_wallet,
                          title: 'Anggaran Bulanan',
                          subtitle: NumberFormat.currency(
                            locale: 'id_ID',
                            symbol: 'Rp ',
                            decimalDigits: 0,
                          ).format(provider.monthlyBudget),
                          onTap: () => _showBudgetDialog(context, provider),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _buildSettingsSection(
                  'Tentang Aplikasi',
                  [
                    _buildSettingsCard(
                      icon: Icons.info_outline,
                      title: 'Versi Aplikasi',
                      subtitle: AppConstants.version,
                    ),
                    const SizedBox(height: 8),
                    _buildSettingsCard(
                      icon: Icons.star_outline,
                      title: 'Beri Rating',
                      subtitle: 'Nilai aplikasi ini di Play Store',
                      onTap: () {
                        // TODO: Implement app rating
                      },
                    ),
                  ],
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryColor,
            ),
          ),
        ),
        ...children,
      ],
    );
  }

  Widget _buildSettingsCard({
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return Card(
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: AppTheme.primaryColor,
          ),
        ),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: trailing ?? (onTap != null ? const Icon(Icons.chevron_right) : null),
        onTap: onTap,
      ),
    );
  }

  Future<void> _showBudgetDialog(
    BuildContext context,
    FinanceProvider provider,
  ) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Atur Anggaran Bulanan'),
        content: TextField(
          controller: _budgetController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            prefixText: 'Rp ',
            labelText: 'Jumlah Anggaran',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              final newBudget = double.tryParse(_budgetController.text);
              if (newBudget != null) {
                provider.updateBudget(newBudget);
                Navigator.pop(context);
              }
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }
} 