import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/finance_provider.dart';
import '../providers/habit_provider.dart';
import '../widgets/finance_summary_card.dart';
import '../widgets/quick_action_fab.dart';
import '../theme/app_theme.dart';
import 'package:intl/intl.dart';
import '../widgets/habit_summary_card.dart';
import '../widgets/hero_card.dart';
import '../screens/finance_stats_screen.dart';
import '../screens/habit_tracker_screen.dart';
import '../widgets/animated_card.dart';
import '../providers/auth_provider.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.primary,
                    theme.colorScheme.secondary,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildGreeting(context),
                    SizedBox(height: 24),
                    _buildQuickStats(),
                  ],
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                AnimatedCard(
                  duration: const Duration(milliseconds: 600),
                  offsetY: 30,
                  child: HeroCard(
                    tag: 'finance_summary',
                    child: FinanceSummaryCard(),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FinanceStatsScreen(),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                AnimatedCard(
                  duration: const Duration(milliseconds: 800),
                  offsetY: 30,
                  child: HeroCard(
                    tag: 'habit_summary',
                    child: HabitSummaryCard(),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HabitTrackerScreen(),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                AnimatedCard(
                  duration: const Duration(milliseconds: 1000),
                  offsetY: 30,
                  child: _buildRecentTransactions(),
                ),
              ]),
            ),
          ),
        ],
      ),
      floatingActionButton: const QuickActionFAB(),
    );
  }

  Widget _buildGreeting(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
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
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Icon(
                  Icons.waving_hand,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Text(
                  'Selamat Datang!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(DateTime.now()),
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentTransactions() {
    return Consumer<FinanceProvider>(
      builder: (context, provider, child) {
        final recentTransactions = provider.entries.take(5).toList();

        return Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Transaksi Terakhir',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (recentTransactions.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('Belum ada transaksi'),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: recentTransactions.length,
                  itemBuilder: (context, index) {
                    final transaction = recentTransactions[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: transaction.isIncome
                            ? AppTheme.successColor
                            : AppTheme.errorColor,
                        child: Icon(
                          transaction.isIncome
                              ? Icons.arrow_upward
                              : Icons.arrow_downward,
                          color: Colors.white,
                        ),
                      ),
                      title: Text(transaction.category),
                      subtitle: Text(
                        DateFormat('dd/MM/yyyy').format(transaction.date),
                      ),
                      trailing: Text(
                        NumberFormat.currency(
                          locale: 'id_ID',
                          symbol: 'Rp ',
                          decimalDigits: 0,
                        ).format(transaction.amount),
                        style: TextStyle(
                          color: transaction.isIncome
                              ? AppTheme.successColor
                              : AppTheme.errorColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHabitProgress() {
    return const HabitSummaryCard();
  }

  Widget _buildQuickStats() {
    return Consumer<FinanceProvider>(
      builder: (context, financeProvider, _) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildQuickStatItem(
              'Pemasukan',
              financeProvider.totalIncome,
              Icons.arrow_upward,
              AppTheme.successColor,
            ),
            _buildQuickStatItem(
              'Pengeluaran',
              financeProvider.totalExpense,
              Icons.arrow_downward,
              AppTheme.errorColor,
            ),
          ],
        );
      },
    );
  }

  Widget _buildQuickStatItem(
      String label, double amount, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(color: Colors.white),
          ),
          Text(
            NumberFormat.currency(
              locale: 'id_ID',
              symbol: 'Rp ',
              decimalDigits: 0,
            ).format(amount),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToStats(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const FinanceStatsScreen(),
      ),
    );
  }
}
