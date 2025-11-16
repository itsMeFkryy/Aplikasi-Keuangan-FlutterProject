import 'package:flutter/material.dart';

class CategoryManagementScreen extends StatefulWidget {
  const CategoryManagementScreen({super.key});

  @override
  State<CategoryManagementScreen> createState() => _CategoryManagementScreenState();
}

class _CategoryManagementScreenState extends State<CategoryManagementScreen> {
  final List<Map<String, dynamic>> _incomeCategories = [
    {'id': 1, 'name': 'Penjualan', 'type': 'income', 'color': Colors.green, 'icon': Icons.shopping_cart},
    {'id': 2, 'name': 'Investasi', 'type': 'income', 'color': Colors.blue, 'icon': Icons.trending_up},
    {'id': 3, 'name': 'Donasi', 'type': 'income', 'color': Colors.orange, 'icon': Icons.volunteer_activism},
  ];

  final List<Map<String, dynamic>> _expenseCategories = [
    {'id': 4, 'name': 'Bahan Baku', 'type': 'expense', 'color': Colors.red, 'icon': Icons.inventory},
    {'id': 5, 'name': 'Gaji Karyawan', 'type': 'expense', 'color': Colors.purple, 'icon': Icons.people},
    {'id': 6, 'name': 'Sewa Tempat', 'type': 'expense', 'color': Colors.brown, 'icon': Icons.business},
    {'id': 7, 'name': 'Listrik & Air', 'type': 'expense', 'color': Colors.amber, 'icon': Icons.bolt},
    {'id': 8, 'name': 'Transportasi', 'type': 'expense', 'color': Colors.deepOrange, 'icon': Icons.directions_car},
  ];

  final _categoryNameController = TextEditingController();
  String _selectedType = 'income';
  Color _selectedColor = Colors.green;
  IconData _selectedIcon = Icons.category;

  final List<Color> _availableColors = [
    Colors.green,
    Colors.blue,
    Colors.red,
    Colors.orange,
    Colors.purple,
    Colors.brown,
    Colors.amber,
    Colors.deepOrange,
    Colors.teal,
    Colors.pink,
  ];

  final List<IconData> _availableIcons = [
    Icons.shopping_cart,
    Icons.trending_up,
    Icons.volunteer_activism,
    Icons.inventory,
    Icons.people,
    Icons.business,
    Icons.bolt,
    Icons.directions_car,
    Icons.restaurant,
    Icons.medical_services,
    Icons.school,
    Icons.home,
    Icons.phone,
    Icons.wifi,
    Icons.water_drop,
  ];

  void _addCategory() {
    if (_categoryNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nama kategori harus diisi'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final newCategory = {
      'id': DateTime.now().millisecondsSinceEpoch,
      'name': _categoryNameController.text,
      'type': _selectedType,
      'color': _selectedColor,
      'icon': _selectedIcon,
    };

    setState(() {
      if (_selectedType == 'income') {
        _incomeCategories.add(newCategory);
      } else {
        _expenseCategories.add(newCategory);
      }
    });

    _categoryNameController.clear();
    Navigator.pop(context);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Kategori "${newCategory['name']}" berhasil ditambah'),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _deleteCategory(int id, String type) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Kategori'),
        content: const Text('Apakah Anda yakin ingin menghapus kategori ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                if (type == 'income') {
                  _incomeCategories.removeWhere((cat) => cat['id'] == id);
                } else {
                  _expenseCategories.removeWhere((cat) => cat['id'] == id);
                }
              });
              Navigator.pop(context);
              
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Kategori berhasil dihapus'),
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

  void _showAddCategoryDialog() {
    _selectedType = 'income';
    _selectedColor = Colors.green;
    _selectedIcon = Icons.category;
    
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Tambah Kategori Baru'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _categoryNameController,
                  decoration: const InputDecoration(
                    labelText: 'Nama Kategori',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedType,
                  items: const [
                    DropdownMenuItem(value: 'income', child: Text('Pemasukan')),
                    DropdownMenuItem(value: 'expense', child: Text('Pengeluaran')),
                  ],
                  onChanged: (value) {
                    setDialogState(() => _selectedType = value!);
                  },
                  decoration: const InputDecoration(
                    labelText: 'Jenis Kategori',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                const Text('Pilih Warna:'),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _availableColors.map((color) {
                    return _buildColorOption(color, setDialogState);
                  }).toList(),
                ),
                const SizedBox(height: 16),
                const Text('Pilih Icon:'),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _availableIcons.map((icon) {
                    return _buildIconOption(icon, setDialogState);
                  }).toList(),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: _addCategory,
              child: const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColorOption(Color color, void Function(void Function()) setDialogState) {
    return GestureDetector(
      onTap: () {
        setDialogState(() => _selectedColor = color);
      },
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: _selectedColor == color
              ? Border.all(color: Colors.black, width: 2)
              : null,
        ),
      ),
    );
  }

  Widget _buildIconOption(IconData icon, void Function(void Function()) setDialogState) {
    return GestureDetector(
      onTap: () {
        setDialogState(() => _selectedIcon = icon);
      },
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: _selectedIcon == icon
              ? Colors.blue.withOpacity(0.1)
              : Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: _selectedIcon == icon
              ? Border.all(color: Colors.blue, width: 2)
              : null,
        ),
        child: Icon(
          icon,
          color: _selectedIcon == icon ? Colors.blue : Colors.grey[600],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kelola Kategori'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddCategoryDialog,
            tooltip: 'Tambah Kategori',
          ),
        ],
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            Container(
              color: Colors.white,
              child: const TabBar(
                labelColor: Colors.blue,
                unselectedLabelColor: Colors.grey,
                indicatorColor: Colors.blue,
                tabs: [
                  Tab(
                    icon: Icon(Icons.arrow_upward),
                    text: 'Pemasukan',
                  ),
                  Tab(
                    icon: Icon(Icons.arrow_downward),
                    text: 'Pengeluaran',
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildCategoryList(_incomeCategories, 'income'),
                  _buildCategoryList(_expenseCategories, 'expense'),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddCategoryDialog,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildCategoryList(List<Map<String, dynamic>> categories, String type) {
    return categories.isEmpty
        ? _buildEmptyState(type)
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return _buildCategoryItem(category);
            },
          );
  }

  Widget _buildCategoryItem(Map<String, dynamic> category) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: category['color'].withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            category['icon'],
            color: category['color'],
            size: 24,
          ),
        ),
        title: Text(
          category['name'],
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          category['type'] == 'income' ? 'Pemasukan' : 'Pengeluaran',
          style: TextStyle(
            color: Colors.grey[600],
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline, color: Colors.red),
          onPressed: () => _deleteCategory(category['id'], category['type']),
          tooltip: 'Hapus Kategori',
        ),
      ),
    );
  }

  Widget _buildEmptyState(String type) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.category_outlined,
            size: 80,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 16),
          Text(
            'Belum ada kategori $type',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[500],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tambahkan kategori pertama Anda',
            style: TextStyle(
              color: Colors.grey[400],
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: _showAddCategoryDialog,
            icon: const Icon(Icons.add),
            label: const Text('Tambah Kategori'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _categoryNameController.dispose();
    super.dispose();
  }
}