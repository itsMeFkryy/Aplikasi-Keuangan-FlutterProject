import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import '../../services/auth_service.dart';
import '../dashboard/dashboard_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _businessNameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String _selectedCategory = 'Makanan & Minuman';
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  final List<String> _categories = [
    'Makanan & Minuman',
    'Fashion',
    'Kerajinan',
    'Jasa',
    'Retail',
    'Lainnya'
  ];

  void _register() async {
    if (_formKey.currentState!.validate()) {
      if (_passwordController.text != _confirmPasswordController.text) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Password tidak sama'),
              backgroundColor: Colors.red[400],
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          );
        }
        return;
      }

      setState(() => _isLoading = true);

      final user = User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text,
        email: _emailController.text,
        phone: _phoneController.text,
        businessName: _businessNameController.text,
        businessCategory: _selectedCategory,
      );

      final success = await AuthService().register(user, _passwordController.text);

      if (mounted) {
        setState(() => _isLoading = false);

        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Registrasi berhasil!'),
              backgroundColor: Colors.green[400],
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const DashboardScreen()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Registrasi gagal, coba lagi'),
              backgroundColor: Colors.red[400],
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 20),
                
                // Logo/Icon
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.person_add_alt_1,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Header
                const Text(
                  'Buat Akun Baru',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Daftarkan bisnis UMKM Anda',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 40),

                // Name Field
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Nama Lengkap',
                    prefixIcon: Icon(Icons.person_outline, color: Colors.grey[600]),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nama harus diisi';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Email Field
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email_outlined, color: Colors.grey[600]),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email harus diisi';
                    }
                    if (!value.contains('@')) {
                      return 'Email tidak valid';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Phone Field
                TextFormField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    labelText: 'Nomor Telepon',
                    prefixIcon: Icon(Icons.phone_outlined, color: Colors.grey[600]),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nomor telepon harus diisi';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Business Name Field
                TextFormField(
                  controller: _businessNameController,
                  decoration: InputDecoration(
                    labelText: 'Nama Usaha',
                    prefixIcon: Icon(Icons.business_center_outlined, color: Colors.grey[600]),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nama usaha harus diisi';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Category Dropdown
                DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  items: _categories.map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() => _selectedCategory = value!);
                  },
                  decoration: InputDecoration(
                    labelText: 'Kategori Bisnis',
                    prefixIcon: Icon(Icons.category_outlined, color: Colors.grey[600]),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                  ),
                ),
                const SizedBox(height: 20),

                // Password Field
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock_outline, color: Colors.grey[600]),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility : Icons.visibility_off,
                        color: Colors.grey[600],
                      ),
                      onPressed: () {
                        setState(() => _obscurePassword = !_obscurePassword);
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password harus diisi';
                    }
                    if (value.length < 6) {
                      return 'Password minimal 6 karakter';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Confirm Password Field
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: _obscureConfirmPassword,
                  decoration: InputDecoration(
                    labelText: 'Konfirmasi Password',
                    prefixIcon: Icon(Icons.lock_outline, color: Colors.grey[600]),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword ? Icons.visibility : Icons.visibility_off,
                        color: Colors.grey[600],
                      ),
                      onPressed: () {
                        setState(() => _obscureConfirmPassword = !_obscureConfirmPassword);
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 30),


                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _register,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'DAFTAR',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                  ),
                ),
                const SizedBox(height: 24),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Sudah punya akun?',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Masuk di sini',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _businessNameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}