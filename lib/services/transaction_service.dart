import '../models/transaction_model.dart';

class TransactionService {
  final List<Transaction> _transactions = [
    Transaction(
      id: '1',
      date: DateTime(2024, 1, 15),
      category: 'Penjualan',
      amount: 5000000,
      description: 'Penjualan produk A',
      type: TransactionType.income,
    ),
    Transaction(
      id: '2',
      date: DateTime(2024, 1, 16),
      category: 'Bahan Baku',
      amount: 2000000,
      description: 'Beli bahan baku',
      type: TransactionType.expense,
    ),
    Transaction(
      id: '3',
      date: DateTime(2024, 1, 17),
      category: 'Penjualan',
      amount: 3000000,
      description: 'Penjualan produk B',
      type: TransactionType.income,
    ),
  ];

  List<Transaction> get transactions => _transactions;

  void addTransaction(Transaction transaction) {
    _transactions.add(transaction);
  }

  void deleteTransaction(String id) {
    _transactions.removeWhere((transaction) => transaction.id == id);
  }

  Map<String, double> getCategoryAnalytics(TransactionType type) {
    final categoryMap = <String, double>{};
    
    for (final transaction in _transactions) {
      if (transaction.type == type) {
        categoryMap[transaction.category] = 
            (categoryMap[transaction.category] ?? 0) + transaction.amount;
      }
    }
    
    return categoryMap;
  }

  Map<String, double> getMonthlySummary(int year) {
    final monthlyData = <String, double>{};
    
    for (int month = 1; month <= 12; month++) {
      final monthlyIncome = _getMonthlyAmount(year, month, TransactionType.income);
      final monthlyExpense = _getMonthlyAmount(year, month, TransactionType.expense);
      monthlyData['$month-income'] = monthlyIncome;
      monthlyData['$month-expense'] = monthlyExpense;
    }
    
    return monthlyData;
  }

  double _getMonthlyAmount(int year, int month, TransactionType type) {
    return _transactions
        .where((t) => 
            t.date.year == year &&
            t.date.month == month &&
            t.type == type)
        .fold(0.0, (sum, transaction) => sum + transaction.amount);
  }

  double getTotalIncome() {
    return _transactions
        .where((t) => t.type == TransactionType.income)
        .fold(0.0, (sum, transaction) => sum + transaction.amount);
  }

  double getTotalExpense() {
    return _transactions
        .where((t) => t.type == TransactionType.expense)
        .fold(0.0, (sum, transaction) => sum + transaction.amount);
  }

  double getBalance() {
    return getTotalIncome() - getTotalExpense();
  }

  List<Transaction> getTransactionsByDateRange(DateTime start, DateTime end) {
    return _transactions.where((transaction) =>
      transaction.date.isAfter(start.subtract(const Duration(days: 1))) && 
      transaction.date.isBefore(end.add(const Duration(days: 1)))
    ).toList();
  }
}