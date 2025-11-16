import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../../services/transaction_service.dart';
import '../../models/transaction_model.dart';
import '../../models/user_model.dart';
import '../transaction/add_transaction_screen.dart';
import '../transaction/transaction_list_screen.dart';
import '../report/report_screen.dart';
import '../profile/profile_screen.dart';
import '../budget/budget_screen.dart';
import '../goals/goals_screen.dart';
import '../category/category_management_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;
  
  final List<Widget> _screens = [
    const HomeTab(),
    const TransactionListScreen(),
    const ReportScreen(),
    const ProfileScreen(),
  ];

  void _showNotifications() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        height: 300,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Text(
                  'Notifikasi',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Spacer(),
                Badge(
                  label: Text('3'),
                  child: Icon(Icons.notifications),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: [
                  _buildNotificationItem(
                    'Pemasukan Tinggi!',
                    'Anda mendapatkan pemasukan tertinggi bulan ini',
                    Icons.trending_up,
                    Colors.green,
                  ),
                  _buildNotificationItem(
                    'Budget Hampir Habis',
                    'Pengeluaran kategori Bahan Baku mencapai 80%',
                    Icons.warning_amber,
                    Colors.orange,
                  ),
                  _buildNotificationItem(
                    'Target Tercapai',
                    'Selamat! Target "Dana Darurat" sudah tercapai',
                    Icons.celebration,
                    Colors.blue,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationItem(String title, String subtitle, IconData icon, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        subtitle: Text(subtitle),
        trailing: Text(
          'Baru',
          style: TextStyle(
            color: Colors.green,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.account_balance_wallet, color: Colors.blue, size: 28),
            SizedBox(width: 8),
            Text(
              'FinGrow',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Badge(
              label: Text('3'),
              child: Icon(Icons.notifications_outlined),
            ),
            onPressed: _showNotifications,
          ),
        ],
      ),
      drawer: _buildDrawer(),
      body: _screens[_currentIndex],
      floatingActionButton: _currentIndex == 1 
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddTransactionScreen(
                      onTransactionAdded: () => setState(() {}),
                    ),
                  ),
                );
              },
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(Icons.add, size: 28),
            )
          : null,
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildDrawer() {
    final user = AuthService().currentUser;
    
    final menuItems = [
      _DrawerItem(Icons.dashboard, 'Dashboard', () => _setIndex(0)),
      _DrawerItem(Icons.receipt_long, 'Transaksi', () => _setIndex(1)),
      _DrawerItem(Icons.bar_chart, 'Laporan', () => _setIndex(2)),
      _DrawerItem(Icons.account_balance_wallet, 'Kelola Budget', () => _navigateTo(const BudgetScreen())),
      _DrawerItem(Icons.flag, 'Target Keuangan', () => _navigateTo(const GoalsScreen())),
      _DrawerItem(Icons.category, 'Kelola Kategori', () => _navigateTo(const CategoryManagementScreen())),
      _DrawerItem(Icons.settings, 'Pengaturan', null),
      _DrawerItem(Icons.help_outline, 'Bantuan', null),
    ];

    return Drawer(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 60, bottom: 20, left: 20, right: 20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.blue.shade700, Colors.lightBlue.shade400],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 35, color: Colors.blue),
                ),
                const SizedBox(height: 12),
                Text(
                  user?.name ?? 'User',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  user?.businessName ?? 'Business Name',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                ...menuItems.map((item) => _buildDrawerItem(item)),
                const Divider(),
              ],
            ),
          ),
          
          Container(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton.icon(
              onPressed: _showLogoutDialog,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade50,
                foregroundColor: Colors.red,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                minimumSize: const Size(double.infinity, 50),
              ),
              icon: const Icon(Icons.logout, size: 20),
              label: const Text('Keluar'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(_DrawerItem item) {
    return ListTile(
      leading: Icon(item.icon, color: Colors.grey[700]),
      title: Text(item.title),
      onTap: item.onTap,
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey[600],
          selectedLabelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          unselectedLabelStyle: const TextStyle(fontSize: 12),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_outlined),
              activeIcon: Icon(Icons.dashboard),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long_outlined),
              activeIcon: Icon(Icons.receipt_long),
              label: 'Transaksi',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart_outlined),
              activeIcon: Icon(Icons.bar_chart),
              label: 'Laporan',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outlined),
              activeIcon: Icon(Icons.person),
              label: 'Profil',
            ),
          ],
        ),
      ),
    );
  }

  void _setIndex(int index) {
    setState(() => _currentIndex = index);
    Navigator.pop(context);
  }

  void _navigateTo(Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Keluar'),
        content: const Text('Apakah Anda yakin ingin keluar dari akun?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: _logout,
            child: const Text('Keluar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _logout() {
    AuthService().logout();
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }
}

class _DrawerItem {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;

  const _DrawerItem(this.icon, this.title, this.onTap);
}

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    final transactionService = TransactionService();
    final authService = AuthService();
    final user = authService.currentUser;

    if (user == null) {
      return const Center(
        child: Text(
          'User tidak ditemukan',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    final totalIncome = transactionService.getTotalIncome();
    final totalExpense = transactionService.getTotalExpense();
    final balance = transactionService.getBalance();
    final transactions = transactionService.transactions;
    final recentTransactions = transactions.take(3).toList();
    
    final categoryAnalytics = transactionService.getCategoryAnalytics(TransactionType.expense);
    final topCategory = categoryAnalytics.isNotEmpty 
        ? categoryAnalytics.entries.reduce((a, b) => a.value > b.value ? a : b).key
        : null;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildWelcomeCard(user, balance),
          const SizedBox(height: 24),
          _buildSectionTitle('Ringkasan Keuangan'),
          const SizedBox(height: 16),
          _buildBalanceOverview(totalIncome, totalExpense),
          const SizedBox(height: 20),
          _buildQuickStats(transactions.length, topCategory),
          const SizedBox(height: 24),
          _buildSectionTitle('Aksi Cepat'),
          const SizedBox(height: 16),
          _buildQuickActions(context),
          const SizedBox(height: 24),
          _buildRecentTransactions(recentTransactions, context),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildWelcomeCard(User user, double balance) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF667eea), Color(0xFF764ba2)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 24,
                backgroundColor: Colors.white,
                child: Icon(Icons.account_balance_wallet, color: Color(0xFF667eea)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Halo, ${user.name}! 👋',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      user.businessName,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            'Saldo saat ini',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
          Text(
            'Rp ${balance.toStringAsFixed(0)}',
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceOverview(double income, double expense) {
    return Row(
      children: [
        _buildBalanceCard('Pemasukan', income, Colors.green, Icons.arrow_upward_rounded),
        const SizedBox(width: 12),
        _buildBalanceCard('Pengeluaran', expense, Colors.red, Icons.arrow_downward_rounded),
      ],
    );
  }

  Widget _buildBalanceCard(String title, double amount, Color color, IconData icon) {
    return Expanded(
      child: _buildCard(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Rp ${amount.toStringAsFixed(0)}',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStats(int transactionCount, String? topCategory) {
    return _buildCard(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Statistik Cepat',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildStatItem('Total Transaksi', '$transactionCount', Icons.receipt, Colors.blue),
              const SizedBox(width: 16),
              _buildStatItem('Kategori Teratas', topCategory ?? '-', Icons.category, Colors.green),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              title,
              style: const TextStyle(
                fontSize: 10,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    final actions = [
      _QuickAction('Tambah Transaksi', Icons.add_circle_outline, Colors.blue, () => _navigateTo(context, const AddTransactionScreen())),
      _QuickAction('Laporan Detail', Icons.analytics_outlined, Colors.green, () => _navigateTo(context, const ReportScreen())),
      _QuickAction('Kelola Budget', Icons.account_balance_wallet, Colors.orange, () => _navigateTo(context, const BudgetScreen())),
      _QuickAction('Target Keuangan', Icons.flag, Colors.purple, () => _navigateTo(context, const GoalsScreen())),
    ];

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      children: actions.map((action) => _buildQuickAction(action)).toList(),
    );
  }

  Widget _buildQuickAction(_QuickAction action) {
    return GestureDetector(
      onTap: action.onTap,
      child: _buildCard(
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: action.color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(action.icon, size: 24, color: action.color),
            ),
            const SizedBox(height: 8),
            Text(
              action.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentTransactions(List<Transaction> transactions, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Transaksi Terbaru',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            TextButton(
              onPressed: () => _navigateTo(context, const TransactionListScreen()),
              child: const Text('Lihat Semua'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        transactions.isEmpty 
            ? _buildEmptyTransaction()
            : Column(children: transactions.map(_buildTransactionItem).toList()),
      ],
    );
  }

  Widget _buildEmptyTransaction() {
    return _buildCard(
      Column(
        children: [
          Icon(Icons.receipt_long_outlined, size: 60, color: Colors.grey[300]),
          const SizedBox(height: 16),
          const Text(
            'Belum ada transaksi',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Tambahkan transaksi pertama Anda',
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ],
      ),
      padding: 40,
    );
  }

  Widget _buildTransactionItem(Transaction transaction) {
    final isIncome = transaction.type == TransactionType.income;
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isIncome ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            isIncome ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
            color: isIncome ? Colors.green : Colors.red,
            size: 20,
          ),
        ),
        title: Text(
          transaction.description,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Text(
          '${transaction.category} • ${_formatDate(transaction.date)}',
          style: TextStyle(color: Colors.grey[600]),
        ),
        trailing: Text(
          'Rp ${transaction.amount.toStringAsFixed(0)}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isIncome ? Colors.green : Colors.red,
          ),
        ),
      ),
    );
  }

  Widget _buildCard(Widget child, {double padding = 16}) {
    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }

  void _navigateTo(BuildContext context, Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

class _QuickAction {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  _QuickAction(this.title, this.icon, this.color, this.onTap);
}