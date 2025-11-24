import 'dart:convert';
import 'dart:io';

class SimpleBackend {
  HttpServer? _server;
  final List<Map<String, dynamic>> _users = [];
  final Map<String, String> _tokens = {};

  Future<void> start() async {
    try {
      _server = await HttpServer.bind('localhost', 3000);
      print('   Backend Server running on http://localhost:3000');
      print('   API Endpoints:');
      print('   POST /api/auth/register');
      print('   POST /api/auth/login'); 
      print('   GET  /api/auth/me');
      print('   GET  /api/test');

      await for (HttpRequest request in _server!) {
        _handleRequest(request);
      }
    } catch (e) {
      print('❌ Failed to start server: $e');
    }
  }

  void _handleRequest(HttpRequest request) {
    try {
      request.response.headers.add('Access-Control-Allow-Origin', '*');
      request.response.headers.add('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS');
      request.response.headers.add('Access-Control-Allow-Headers', 'Content-Type, Authorization');

      if (request.method == 'OPTIONS') {
        request.response.statusCode = 200;
        request.response.close();
        return;
      }

      final path = request.uri.path;
      final method = request.method;

      print('📨 $method $path');

      if (method == 'POST' && path == '/api/auth/register') {
        _handleRegister(request);
      } else if (method == 'POST' && path == '/api/auth/login') {
        _handleLogin(request);
      } else if (method == 'GET' && path == '/api/auth/me') {
        _handleGetMe(request);
      } else if (method == 'GET' && path == '/api/test') {
        _sendResponse(request, 200, {'status': 'success', 'message': 'Backend connected!'});
      } else if (method == 'GET' && path == '/') {
        _sendResponse(request, 200, {'message': 'Financial Backend API is running!'});
      } else {
        _sendResponse(request, 404, {'error': 'Endpoint not found'});
      }
    } catch (e) {
      print('💥 Request handling error: $e');
      _sendResponse(request, 500, {'error': 'Internal server error'});
    }
  }

  void _handleRegister(HttpRequest request) async {
    try {
      final body = await utf8.decoder.bind(request).join();
      print('📨 Register body: $body'); // Debug log
      
      final data = jsonDecode(body);

      final String name = data['name']?.toString() ?? '';
      final String email = data['email']?.toString() ?? '';
      final String password = data['password']?.toString() ?? '';
      final String phone = data['phone']?.toString() ?? '';
      final String businessName = data['business_name']?.toString() ?? '';
      final String businessCategory = data['business_category']?.toString() ?? 'Lainnya';

      if (name.isEmpty || email.isEmpty || password.isEmpty) {
        _sendResponse(request, 400, {
          'success': false,
          'message': 'Name, email, and password are required',
        });
        return;
      }

      if (_users.any((user) => user['email'] == email)) {
        _sendResponse(request, 400, {
          'success': false,
          'message': 'User already exists with this email',
        });
        return;
      }

      // Create user
      final user = {
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'name': name,
        'email': email,
        'phone': phone,
        'businessName': businessName,
        'businessCategory': businessCategory,
        'password': password,
      };

      _users.add(user);
      final token = _generateToken(user['id']!);
      _tokens[token] = user['id']!;

      print('User registered: $email');

      _sendResponse(request, 201, {
        'success': true,
        'message': 'User registered successfully',
        'token': token,
        'user': {
          'id': user['id'],
          'name': user['name'],
          'email': user['email'],
          'phone': user['phone'],
          'businessName': user['businessName'],
          'businessCategory': user['businessCategory'],
        },
      });

    } catch (e) {
      print('💥 Register error: $e');
      _sendResponse(request, 400, {
        'success': false,
        'message': 'Invalid request data: ${e.toString()}',
      });
    }
  }

  void _handleLogin(HttpRequest request) async {
    try {
      final body = await utf8.decoder.bind(request).join();
      print('Login body: $body'); 
      
      final data = jsonDecode(body);

      final String email = data['email']?.toString() ?? '';
      final String password = data['password']?.toString() ?? '';

      if (email.isEmpty || password.isEmpty) {
        _sendResponse(request, 400, {
          'success': false,
          'message': 'Email and password are required',
        });
        return;
      }

      final user = _users.firstWhere(
        (user) => user['email'] == email && user['password'] == password,
        orElse: () => {},
      );

      if (user.isEmpty) {
        _sendResponse(request, 401, {
          'success': false,
          'message': 'Invalid email or password',
        });
        return;
      }

      final token = _generateToken(user['id']!);
      _tokens[token] = user['id']!;

      print('✅ User logged in: $email'); 

      _sendResponse(request, 200, {
        'success': true,
        'message': 'Login successful',
        'token': token,
        'user': {
          'id': user['id'],
          'name': user['name'],
          'email': user['email'],
          'phone': user['phone'],
          'businessName': user['businessName'],
          'businessCategory': user['businessCategory'],
        },
      });

    } catch (e) {
      print('💥 Login error: $e');
      _sendResponse(request, 400, {
        'success': false,
        'message': 'Invalid request data: ${e.toString()}',
      });
    }
  }

  void _handleGetMe(HttpRequest request) {
    try {
      final authHeader = request.headers['authorization']?.first;
      final token = authHeader?.replaceFirst('Bearer ', '') ?? '';

      if (token.isEmpty || !_tokens.containsKey(token)) {
        _sendResponse(request, 401, {
          'success': false,
          'message': 'Invalid token',
        });
        return;
      }

      final userId = _tokens[token]!;
      final user = _users.firstWhere(
        (user) => user['id'] == userId,
        orElse: () => {},
      );

      if (user.isEmpty) {
        _sendResponse(request, 404, {
          'success': false,
          'message': 'User not found',
        });
        return;
      }

      _sendResponse(request, 200, {
        'success': true,
        'user': {
          'id': user['id'],
          'name': user['name'],
          'email': user['email'],
          'phone': user['phone'],
          'businessName': user['businessName'],
          'businessCategory': user['businessCategory'],
        },
      });

    } catch (e) {
      print('GetMe error: $e');
      _sendResponse(request, 500, {
        'success': false,
        'message': 'Internal server error',
      });
    }
  }

  void _sendResponse(HttpRequest request, int statusCode, dynamic data) {
    try {
      request.response
        ..statusCode = statusCode
        ..headers.contentType = ContentType.json
        ..write(jsonEncode(data))
        ..close();
    } catch (e) {
      print('Response error: $e');
    }
  }

  String _generateToken(String userId) {
    return 'token_${userId}_${DateTime.now().millisecondsSinceEpoch}';
  }

  void stop() {
    _server?.close();
    print('Backend Server stopped');
  }
}

void main() async {
  final backend = SimpleBackend();
  
  ProcessSignal.sigint.watch().listen((_) {
    print('\n Shutting down server...');
    backend.stop();
    exit(0);
  });

  await backend.start();
}