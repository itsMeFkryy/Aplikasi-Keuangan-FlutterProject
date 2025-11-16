import 'package:flutter/material.dart';

class FinancialGoal {
  final String id;
  final String title;
  final double targetAmount;
  final double currentAmount;
  final DateTime deadline;
  final Color color;
  final IconData icon;

  FinancialGoal({
    required this.id,
    required this.title,
    required this.targetAmount,
    required this.currentAmount,
    required this.deadline,
    required this.color,
    required this.icon,
  });

  double get progress => targetAmount > 0 ? currentAmount / targetAmount : 0;
  double get remaining => targetAmount - currentAmount;
  int get daysLeft => deadline.difference(DateTime.now()).inDays;
}

class GoalsScreen extends StatefulWidget {
  const GoalsScreen({super.key});

  @override
  State<GoalsScreen> createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> {
  final List<FinancialGoal> _goals = [
    FinancialGoal(
      id: '1',
      title: 'Beli Laptop Baru',
      targetAmount: 10000000,
      currentAmount: 3500000,
      deadline: DateTime(2024, 12, 31),
      color: Colors.blue,
      icon: Icons.laptop,
    ),
    FinancialGoal(
      id: '2', 
      title: 'Dana Darurat',
      targetAmount: 20000000,
      currentAmount: 12000000,
      deadline: DateTime(2024, 6, 30),
      color: Colors.green,
      icon: Icons.emergency,
    ),
    FinancialGoal(
      id: '3',
      title: 'Renovasi Toko',
      targetAmount: 50000000,
      currentAmount: 15000000,
      deadline: DateTime(2024, 9, 30),
      color: Colors.orange,
      icon: Icons.store,
    ),
  ];

  void _addGoal() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Buat Target Keuangan Baru'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const TextField(
              decoration: InputDecoration(labelText: 'Nama Target'),
            ),
            const SizedBox(height: 12),
            const TextField(
              decoration: InputDecoration(labelText: 'Target Amount'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            const TextField(
              decoration: InputDecoration(labelText: 'Tanggal Target'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Add goal logic here
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Target berhasil dibuat!')),
                );
              },
              child: const Text('Simpan Target'),
            ),
          ],
        ),
      ),
    );
  }

  void _addToGoal(String goalId) {
    final goalIndex = _goals.indexWhere((goal) => goal.id == goalId);
    if (goalIndex == -1) return;

    final TextEditingController amountController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tambah Dana ke Target'),
        content: TextField(
          controller: amountController,
          decoration: const InputDecoration(
            labelText: 'Jumlah',
            prefixText: 'Rp ',
          ),
          keyboardType: TextInputType.number,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              final amount = double.tryParse(amountController.text) ?? 0;
              if (amount > 0) {
                setState(() {
                  // Update the goal amount - FIX: Actually use the goal variable
                  _goals[goalIndex] = FinancialGoal(
                    id: _goals[goalIndex].id,
                    title: _goals[goalIndex].title,
                    targetAmount: _goals[goalIndex].targetAmount,
                    currentAmount: _goals[goalIndex].currentAmount + amount,
                    deadline: _goals[goalIndex].deadline,
                    color: _goals[goalIndex].color,
                    icon: _goals[goalIndex].icon,
                  );
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Berhasil menambah Rp ${amount.toStringAsFixed(0)} ke target'),
                    backgroundColor: Colors.green,
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Masukkan jumlah yang valid'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: const Text('Tambah'),
          ),
        ],
      ),
    );
  }

  void _deleteGoal(String goalId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Target'),
        content: const Text('Apakah Anda yakin ingin menghapus target ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _goals.removeWhere((goal) => goal.id == goalId);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Target berhasil dihapus'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final totalTarget = _goals.fold(0.0, (sum, goal) => sum + goal.targetAmount);
    final totalSaved = _goals.fold(0.0, (sum, goal) => sum + goal.currentAmount);
    final overallProgress = totalTarget > 0 ? totalSaved / totalTarget : 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Target Keuangan'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addGoal,
            tooltip: 'Tambah Target',
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
                colors: [Colors.green.shade600, Colors.blue.shade600],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.green.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                const Text(
                  'Total Progress Target',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Rp ${totalSaved.toStringAsFixed(0)}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'dari Rp ${totalTarget.toStringAsFixed(0)}',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 12),
                LinearProgressIndicator(
                  value: overallProgress.toDouble(),
                  backgroundColor: Colors.white.withOpacity(0.3),
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                  minHeight: 8,
                  borderRadius: BorderRadius.circular(4),
                ),
                const SizedBox(height: 8),
                Text(
                  '${(overallProgress * 100).toStringAsFixed(1)}% Tercapai',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          // Goals List
          Expanded(
            child: _goals.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _goals.length,
                    itemBuilder: (context, index) {
                      final goal = _goals[index];
                      return _buildGoalItem(goal);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addGoal,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildGoalItem(FinancialGoal goal) {
    final progress = goal.progress;
    final isCompleted = progress >= 1;
    final daysLeft = goal.daysLeft;
    final isOverdue = daysLeft < 0;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
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
                    color: goal.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(goal.icon, color: goal.color, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        goal.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Rp ${goal.currentAmount.toStringAsFixed(0)} / Rp ${goal.targetAmount.toStringAsFixed(0)}',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isCompleted)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'SELESAI',
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: progress > 1 ? 1 : progress,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(
                isCompleted ? Colors.green : goal.color,
              ),
              minHeight: 6,
              borderRadius: BorderRadius.circular(3),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${(progress * 100).toStringAsFixed(1)}%',
                  style: TextStyle(
                    color: isCompleted ? Colors.green : goal.color,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Text(
                  isOverdue 
                    ? 'Terlambat ${daysLeft.abs()} hari'
                    : 'Sisa: $daysLeft hari',
                  style: TextStyle(
                    color: isOverdue ? Colors.red : Colors.grey[600],
                    fontSize: 12,
                    fontWeight: isOverdue ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () => _deleteGoal(goal.id),
                      icon: Icon(Icons.delete_outline, color: Colors.grey[400], size: 18),
                      tooltip: 'Hapus Target',
                    ),
                    const SizedBox(width: 4),
                    ElevatedButton(
                      onPressed: () => _addToGoal(goal.id),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        backgroundColor: goal.color,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text(
                        'Tambah Dana',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.flag_outlined,
            size: 80,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 16),
          const Text(
            'Belum ada target keuangan',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Buat target pertama Anda untuk mengatur keuangan',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: _addGoal,
            icon: const Icon(Icons.add),
            label: const Text('Buat Target Pertama'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }
}