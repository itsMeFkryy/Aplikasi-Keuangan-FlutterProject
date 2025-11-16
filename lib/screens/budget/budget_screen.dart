import 'package:flutter/material.dart';

class Budget {
  final String category;
  final double allocated;
  final double spent;
  final Color color;
  final IconData icon;

  Budget({
    required this.category,
    required this.allocated,
    required this.spent,
    required this.color,
    required this.icon,
  });

  double get remaining => allocated - spent;
  double get percentage => allocated > 0 ? (spent / allocated) * 100 : 0;
}

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({super.key});

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  final List<Budget> _budgets = [
    Budget(
      category: 'Bahan Baku',
      allocated: 5000000,
      spent: 3200000,
      color: Colors.blue,
      icon: Icons.shopping_basket,
    ),
    Budget(
      category: 'Gaji Karyawan', 
      allocated: 3000000,
      spent: 3000000,
      color: Colors.green,
      icon: Icons.people,
    ),
    Budget(
      category: 'Transportasi',
      allocated: 1000000,
      spent: 750000,
      color: Colors.orange,
      icon: Icons.directions_car,
    ),
    Budget(
      category: 'Marketing',
      allocated: 2000000,
      spent: 1200000,
      color: Colors.purple,
      icon: Icons.campaign,
    ),
  ];

  void _addBudget() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tambah Budget Baru'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Kategori'),
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Jumlah Budget'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Budget berhasil ditambah!')),
              );
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final totalAllocated = _budgets.fold(0.0, (sum, budget) => sum + budget.allocated);
    final totalSpent = _budgets.fold(0.0, (sum, budget) => sum + budget.spent);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengelolaan Budget'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addBudget,
          ),
        ],
      ),
      body: Column(
        children: [
          // Header Summary
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.blue.shade600, Colors.purple.shade600],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                const Text(
                  'Total Budget',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Rp ${totalAllocated.toStringAsFixed(0)}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: totalAllocated > 0 ? totalSpent / totalAllocated : 0,
                  backgroundColor: Colors.white.withOpacity(0.3),
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                ),
                const SizedBox(height: 4),
                Text(
                  'Terpakai: Rp ${totalSpent.toStringAsFixed(0)}',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          // Budget List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _budgets.length,
              itemBuilder: (context, index) {
                final budget = _budgets[index];
                return _buildBudgetItem(budget);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBudgetItem(Budget budget) {
    final percentage = budget.percentage;
    final isOverBudget = percentage > 100;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: budget.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(budget.icon, color: budget.color, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        budget.category,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'Rp ${budget.spent.toStringAsFixed(0)} / Rp ${budget.allocated.toStringAsFixed(0)}',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '${percentage.toStringAsFixed(0)}%',
                  style: TextStyle(
                    color: isOverBudget ? Colors.red : Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: percentage > 100 ? 1 : percentage / 100,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(
                isOverBudget ? Colors.red : Colors.green,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Sisa: Rp ${budget.remaining.toStringAsFixed(0)}',
                  style: TextStyle(
                    color: budget.remaining < 0 ? Colors.red : Colors.green,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (isOverBudget)
                  Text(
                    'Over Budget!',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}