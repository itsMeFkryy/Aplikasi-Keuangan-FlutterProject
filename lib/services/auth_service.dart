import '../models/user_model.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  User? _currentUser;
  
  User? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;

  Future<bool> login(String email, String password) async {
    // Simulasi login
    await Future.delayed(const Duration(seconds: 1));
    
    if (email == 'demo@umkm.com' && password == '123456') {
      _currentUser = User(
        id: '1',
        name: 'Demo User',
        email: email,
        phone: '08123456789',
        businessName: 'UMKM Demo',
        businessCategory: 'Makanan & Minuman',
      );
      return true;
    }
    return false;
  }

  Future<bool> register(User user, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    _currentUser = user;
    return true;
  }

  void logout() {
    _currentUser = null;
  }
}