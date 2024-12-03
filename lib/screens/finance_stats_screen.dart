import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';
import '../providers/finance_provider.dart';
import 'package:provider/provider.dart';  
import '../widgets/custom_app_bar.dart';
import '../widgets/skeleton_loading.dart';

class FinanceStatsScreen extends StatelessWidget {
  const FinanceStatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Consumer<FinanceProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return ListView.builder(
            itemCount: 3,
            padding: const EdgeInsets.all(16),
            itemBuilder: (context, index) => const Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: SkeletonCard(),
            ),
          );
        }
        
        final isDarkMode = Theme.of(context).brightness == Brightness.dark;
        
        return DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: CustomAppBar(
              title: 'Statistik Keuangan',
              backgroundColor: theme.colorScheme.primary,
              textColor: Colors.white,
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(48),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.white.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                  ),
                  child: const TabBar(
                    tabs: [
                      Tab(text: 'Pengeluaran'),
                      Tab(text: 'Pemasukan'),
                    ],
                    indicatorColor: Colors.white,
                    indicatorWeight: 3,
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.white60,
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    unselectedLabelStyle: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
            body: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    theme.colorScheme.primary,
                    theme.colorScheme.secondary,
                    isDarkMode ? AppTheme.darkBgColor : Colors.white,
                    isDarkMode ? AppTheme.darkBgColor : Colors.white,
                  ],
                  stops: const [0.0, 0.3, 0.3, 1.0],
                ),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: _buildHeaderStats(),
                  ),
                  const SizedBox(height: 24),
                  // Content Section
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: isDarkMode ? const Color.fromARGB(255, 31, 31, 31) : Colors.white,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                        child: TabBarView(
                          children: [
                            _buildExpenseStats(),
                            _buildIncomeStats(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeaderStats() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Consumer<FinanceProvider>(
        builder: (context, provider, _) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatCard(
                'Pemasukan',
                provider.totalIncome,
                Icons.arrow_upward,
                AppTheme.successColor,
              ),
              _buildStatCard(
                'Pengeluaran',
                provider.totalExpense,
                Icons.arrow_downward,
                AppTheme.errorColor,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStatCard(String title, double amount, IconData icon, Color color) {
    return Builder(
      builder: (context) {
        final isDarkMode = Theme.of(context).brightness == Brightness.dark;
        
        return Container(
          width: 160,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDarkMode ? const Color.fromARGB(255, 27, 27, 27) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isDarkMode ? 0.3 : 0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                  Icon(icon, color: color, size: 20),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                NumberFormat.currency(
                  locale: 'id_ID',
                  symbol: 'Rp ',
                  decimalDigits: 0,
                ).format(amount),
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black87,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      }
    );
  }

  Widget _buildExpenseStats() {
    return Builder(
      builder: (context) {
        final isDarkMode = Theme.of(context).brightness == Brightness.dark;
        
        return SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              _buildChartCard(
                'Pengeluaran per Kategori',
                SfCircularChart(
                  margin: EdgeInsets.zero,
                  backgroundColor: isDarkMode ? const Color.fromARGB(255, 18, 18, 18) : Colors.white,
                  legend: Legend(
                    isVisible: true,
                    position: LegendPosition.bottom,
                    overflowMode: LegendItemOverflowMode.wrap,
                    textStyle: TextStyle(
                      color: isDarkMode ? Colors.white70 : Colors.black87,
                    ),
                  ),
                  series: <CircularSeries>[
                    DoughnutSeries<ExpenseData, String>(
                      dataSource: [
                        ExpenseData('Makan', 2000000),
                        ExpenseData('Transport', 800000),
                        ExpenseData('Hiburan', 700000),
                        ExpenseData('Belanja', 1200000),
                        ExpenseData('Utilitas', 500000),
                      ],
                      xValueMapper: (ExpenseData data, _) => data.category,
                      yValueMapper: (ExpenseData data, _) => data.amount,
                      dataLabelSettings: DataLabelSettings(
                        isVisible: true,
                        labelPosition: ChartDataLabelPosition.outside,
                        textStyle: TextStyle(
                          color: isDarkMode ? Colors.white70 : Colors.black87,
                          fontSize: 12,
                        ),
                        useSeriesColor: true,
                        labelIntersectAction: LabelIntersectAction.shift,
                        builder: (dynamic data, dynamic point, dynamic series,
                            int pointIndex, int seriesIndex) {
                          return Text(
                            NumberFormat.compactCurrency(
                              locale: 'id_ID',
                              symbol: 'Rp ',
                              decimalDigits: 0,
                            ).format(data.amount),
                            style: TextStyle(
                              color: isDarkMode ? Colors.white70 : Colors.black87,
                              fontSize: 12,
                            ),
                          );
                        },
                      ),
                      enableTooltip: true,
                      animationDuration: 1500,
                      explode: true,
                      explodeIndex: 0,
                      explodeOffset: '10%',
                    ),
                  ],
                  annotations: <CircularChartAnnotation>[
                    CircularChartAnnotation(
                      widget: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Total',
                            style: TextStyle(
                              color: isDarkMode ? Colors.white70 : Colors.black87,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            'Rp 5,2 Jt',
                            style: TextStyle(
                              color: isDarkMode ? Colors.white : Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              _buildChartCard(
                'Tren Pengeluaran',
                SfCartesianChart(
                  margin: EdgeInsets.zero,
                  backgroundColor: isDarkMode ? const Color.fromARGB(255, 18, 18, 18) : Colors.white,
                  primaryXAxis: CategoryAxis(
                    majorGridLines: const MajorGridLines(width: 0),
                    labelStyle: TextStyle(
                      color: isDarkMode ? Colors.white70 : Colors.black87,
                    ),
                  ),
                  primaryYAxis: NumericAxis(
                    numberFormat: NumberFormat.compact(locale: 'id_ID'),
                    majorGridLines: const MajorGridLines(width: 0.5, dashArray: [5, 5]),
                    labelStyle: TextStyle(
                      color: isDarkMode ? Colors.white70 : Colors.black87,
                    ),
                  ),
                  series: <ChartSeries>[
                    SplineAreaSeries<ExpenseTrend, String>(
                      dataSource: [
                        ExpenseTrend('Jan', 3000000),
                        ExpenseTrend('Feb', 3500000),
                        ExpenseTrend('Mar', 3200000),
                        ExpenseTrend('Apr', 3800000),
                      ],
                      xValueMapper: (ExpenseTrend data, _) => data.month,
                      yValueMapper: (ExpenseTrend data, _) => data.amount,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppTheme.primaryColor.withOpacity(0.3),
                          AppTheme.primaryColor.withOpacity(0.1),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }
    );
  }

  Widget _buildChartCard(String title, Widget chart) {
    return Builder(
      builder: (context) {
        final isDarkMode = Theme.of(context).brightness == Brightness.dark;
        
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDarkMode ? const Color.fromARGB(255, 18, 18, 18) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isDarkMode ? 0.3 : 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 300,
                child: chart,
              ),
            ],
          ),
        );
      }
    );
  }

  Widget _buildIncomeStats() {
    // Implementasi serupa untuk pemasukan
    return const Center(child: Text('Statistik Pemasukan'));
  }
}

class ExpenseData {
  final String category;
  final double amount;

  ExpenseData(this.category, this.amount);
}

class ExpenseTrend {
  final String month;
  final double amount;

  ExpenseTrend(this.month, this.amount);
} 