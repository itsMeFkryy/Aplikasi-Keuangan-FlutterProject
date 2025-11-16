import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../auth/login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _logout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Keluar'),
        content: const Text('Apakah Anda yakin ingin keluar?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              AuthService().logout();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false,
              );
            },
            child: const Text('Keluar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = AuthService().currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text('Profil Pengguna')),
      body: user == null
          ? const Center(child: Text('Tidak ada data pengguna'))
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Profile Info
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          const CircleAvatar(
                            radius: 40,
                            child: Icon(Icons.person, size: 40),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            user.name,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(user.email),
                          const SizedBox(height: 16),
                          _buildInfoRow('Nama Usaha', user.businessName),
                          _buildInfoRow('Kategori', user.businessCategory),
                          _buildInfoRow('Telepon', user.phone),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Actions
                  Card(
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.edit),
                          title: const Text('Edit Profil'),
                          onTap: () {
                            // Fitur edit profil akan datang
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Fitur edit profil akan datang')),
                            );
                          },
                        ),
                        const Divider(),
                        ListTile(
                          leading: const Icon(Icons.backup),
                          title: const Text('Backup Data'),
                          onTap: () {
                            // Fitur backup akan datang
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Fitur backup akan datang')),
                            );
                          },
                        ),
                        const Divider(),
                        ListTile(
                          leading: const Icon(Icons.logout, color: Colors.red),
                          title: const Text('Keluar', style: TextStyle(color: Colors.red)),
                          onTap: () => _logout(context),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const Text(': '),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}