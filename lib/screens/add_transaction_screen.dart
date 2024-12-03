import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/finance_entry.dart';
import '../models/finance_category.dart';
import '../providers/finance_provider.dart';
import '../theme/app_theme.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  late DateTime _selectedDate;
  late TransactionType _transactionType;
  String? _selectedCategoryId;
  final _amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _transactionType = TransactionType.expense;
  }

  void _handleSubmit() {
    if (!_formKey.currentState!.validate() || _selectedCategoryId == null) return;

    final amount = double.parse(_amountController.text.replaceAll('.', ''));
    final entry = FinanceEntry(
      id: const Uuid().v4(),
      amount: amount,
      category: _selectedCategoryId!,
      date: _selectedDate,
      isIncome: _transactionType == TransactionType.income,
    );

    context.read<FinanceProvider>().addEntry(entry);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 100,
            pinned: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.secondary,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
              title: const Text(
                'Tambah Transaksi',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: true,
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                color: isDarkMode ? AppTheme.darkBgColor : AppTheme.lightBgColor,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(30),
                ),
              ),
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTransactionTypeSelector(),
                      const SizedBox(height: 24),
                      _buildAmountField(),
                      const SizedBox(height: 24),
                      _buildCategorySelector(),
                      const SizedBox(height: 24),
                      _buildDateSelector(),
                      const SizedBox(height: 32),
                      _buildSubmitButton(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionTypeSelector() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Center(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: isDarkMode ? AppTheme.darkCardColor : Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: SegmentedButton<TransactionType>(
          style: ButtonStyle(
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          segments: [
            ButtonSegment(
              value: TransactionType.expense,
              label: Text(
                'Pengeluaran',
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              icon: Icon(
                Icons.arrow_downward,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            ButtonSegment(
              value: TransactionType.income,
              label: Text(
                'Pemasukan', 
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              icon: Icon(
                Icons.arrow_upward,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
          ],
          selected: {_transactionType},
          onSelectionChanged: (Set<TransactionType> newSelection) {
            setState(() {
              _transactionType = newSelection.first;
              _selectedCategoryId = null;
            });
          },
        ),
      ),
    );
  }

  Widget _buildAmountField() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return TextFormField(
      controller: _amountController,
      keyboardType: TextInputType.number,
      style: TextStyle(
        color: isDarkMode ? Colors.white : Colors.black,
      ),
      decoration: InputDecoration(
        labelText: 'Jumlah',
        prefixIcon: Icon(
          Icons.attach_money,
          color: isDarkMode ? Colors.white70 : Colors.grey[600],
        ),
        prefixText: 'Rp ',
        filled: true,
        fillColor: isDarkMode ? AppTheme.darkCardColor : Colors.grey[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDarkMode ? Colors.grey[700]! : Colors.grey[300]!,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDarkMode ? Colors.grey[700]! : Colors.grey[300]!,
          ),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Mohon masukkan jumlah';
        }
        return null;
      },
    );
  }

  Widget _buildCategorySelector() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final categories = _transactionType == TransactionType.expense 
        ? expenseCategories 
        : incomeCategories;
    
    return DropdownButtonFormField<String>(
      value: _selectedCategoryId,
      decoration: InputDecoration(
        labelText: 'Kategori',
        filled: true,
        fillColor: isDarkMode ? AppTheme.darkCardColor : Colors.grey[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDarkMode ? Colors.grey[700]! : Colors.grey[300]!,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDarkMode ? Colors.grey[700]! : Colors.grey[300]!,
          ),
        ),
      ),
      dropdownColor: isDarkMode ? AppTheme.darkCardColor : Colors.white,
      style: TextStyle(
        color: isDarkMode ? Colors.white : Colors.black,
      ),
      items: categories.map((category) {
        return DropdownMenuItem(
          value: category.id,
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  IconData(
                    int.parse(category.icon),
                    fontFamily: 'MaterialIcons',
                  ),
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                category.name,
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
            ],
          ),
        );
      }).toList(),
      onChanged: (String? value) {
        setState(() {
          _selectedCategoryId = value;
        });
      },
      validator: (value) {
        if (value == null) {
          return 'Mohon pilih kategori';
        }
        return null;
      },
    );
  }

  Widget _buildDateSelector() {
    return InkWell(
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: _selectedDate,
          firstDate: DateTime(2000),
          lastDate: DateTime.now(),
        );
        if (picked != null) {
          setState(() {
            _selectedDate = picked;
          });
        }
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(Icons.calendar_today, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Tanggal',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
                Text(
                  DateFormat('dd MMMM yyyy').format(_selectedDate),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _handleSubmit,
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text('Simpan Transaksi'),
      ),
    );
  }
} 