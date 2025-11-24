import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  static const String baseUrl = 'http://10.0.2.2:3000/api';
  
  User? _currentUser;
  String? _token;
  
  User? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;

  Future<bool> login(String email, String password) async {
    try {
      print('[LOGIN] Attempting: $email');
      
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      ).timeout(const Duration(seconds: 10));

      print('[LOGIN] Status: ${response.statusCode}');
      print('[LOGIN] Body: ${response.body}');

      final data = jsonDecode(response.body);
      
      if (data['success'] == true) {
        print('[LOGIN] Success!');
        _currentUser = User.fromJson(data['user']);
        _token = data['token'];
        return true;
      } else {
        print('❌ [LOGIN] Failed: ${data['message']}');
        return false;
      }
    } catch (e) {
      print('[LOGIN] Error: $e');
      return false;
    }
  }

  Future<bool> register(User user, String password) async {
    try {
      print('[REGISTER] Sending: ${user.email}');
      print('[REGISTER] Data: ${user.toJson()}');
      
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': user.name,
          'email': user.email,
          'phone': user.phone,
          'business_name': user.businessName,
          'business_category': user.businessCategory,
          'password': password,
        }),
      ).timeout(const Duration(seconds: 10));

      print('[REGISTER] Status: ${response.statusCode}');
      print('[REGISTER] Response: ${response.body}');

      final data = jsonDecode(response.body);
      
      if (data['success'] == true) {
        print('[REGISTER] Success!');
        _currentUser = User.fromJson(data['user']);
        _token = data['token'];
        return true;
      } else {
        print('[REGISTER] Failed: ${data['message']}');
        return false;
      }
    } catch (e) {
      print('[REGISTER] Error: $e');
      return false;
    }
  }

  Future<bool> autoLogin() async {
    if (_token == null) return false;
    
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/auth/me'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_token',
        },
      ).timeout(const Duration(seconds: 10));

      final data = jsonDecode(response.body);
      
      if (data['success'] == true) {
        _currentUser = User.fromJson(data['user']);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  void logout() {
    _currentUser = null;
    _token = null;
  }
}