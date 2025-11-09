import 'package:flutter/material.dart';
import '../../services/transaction_service.dart';

class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final transactionService = TransactionService();
    final income = transactionService.getTotalIncome();
    final expense = transactionService.getTotalExpense();
    final balance = transactionService.getBalance();

    return Scaffold(
      appBar: AppBar(title: const Text('Laporan Keuangan')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Summary Cards
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildSummaryRow('Total Pemasukan', income, Colors.green),
                    _buildSummaryRow('Total Pengeluaran', expense, Colors.red),
                    const Divider(),
                    _buildSummaryRow('Saldo Bersih', balance, Colors.blue),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Simple Chart
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Perbandingan Pemasukan & Pengeluaran',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildChart(income, expense),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String title, double amount, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          Text(
            'Rp ${amount.toStringAsFixed(0)}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChart(double income, double expense) {
    final total = income + expense;
    final incomePercentage = total > 0 ? (income / total) * 100 : 0;
    final expensePercentage = total > 0 ? (expense / total) * 100 : 0;

    return Column(
      children: [
        // Income Bar
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              const Icon(Icons.arrow_upward, color: Colors.green, size: 16),
              const SizedBox(width: 8),
              const Text('Pemasukan'),
              const Spacer(),
              Text('${incomePercentage.toStringAsFixed(1)}%'),
            ],
          ),
        ),
        LinearProgressIndicator(
          value: incomePercentage / 100,
          backgroundColor: Colors.green[100],
          color: Colors.green,
        ),
        const SizedBox(height: 16),

        // Expense Bar
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              const Icon(Icons.arrow_downward, color: Colors.red, size: 16),
              const SizedBox(width: 8),
              const Text('Pengeluaran'),
              const Spacer(),
              Text('${expensePercentage.toStringAsFixed(1)}%'),
            ],
          ),
        ),
        LinearProgressIndicator(
          value: expensePercentage / 100,
          backgroundColor: Colors.red[100],
          color: Colors.red,
        ),
      ],
    );
  }
}