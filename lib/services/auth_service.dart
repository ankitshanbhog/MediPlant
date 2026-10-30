import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../data/database_helper.dart';
import '../data/models/user_model.dart';
import 'backend_recognition_service.dart';

class AuthService {
  static const String _tokenKey = 'mediplant_auth_token';
  static const String _userKey = 'mediplant_cached_user';
  static const String _activeRoleKey = 'mediplant_active_role';

  String? _token;
  UserModel? _currentUser;
  String _baseUrl = BackendRecognitionService.defaultBaseUrl;

  String? get token => _token;
  UserModel? get currentUser => _currentUser;
  String get baseUrl => _baseUrl;

  void updateBaseUrl(String url) {
    _baseUrl = url.endsWith('/') ? url.substring(0, url.length - 1) : url;
  }

  Future<List<String>> _getCandidateUrls() async {
    final list = <String>[];
    try {
      final savedUrl = await DatabaseHelper.instance.getSetting('custom_backend_url');
      if (savedUrl != null && savedUrl.trim().isNotEmpty) {
        final clean = savedUrl.trim().endsWith('/') ? savedUrl.trim().substring(0, savedUrl.trim().length - 1) : savedUrl.trim();
        list.add(clean);
      }
    } catch (_) {}
    for (final u in BackendRecognitionService.candidateUrls) {
      if (!list.contains(u)) list.add(u);
    }
    if (!list.contains(_baseUrl)) list.add(_baseUrl);
    return list;
  }

  /// Initialize and restore existing session from local SQLite cache
  Future<UserModel?> initializeSession() async {
    try {
      final savedUrl = await DatabaseHelper.instance.getSetting('custom_backend_url');
      if (savedUrl != null && savedUrl.trim().isNotEmpty) {
        updateBaseUrl(savedUrl.trim());
      }

      _token = await DatabaseHelper.instance.getSetting(_tokenKey);
      final cachedUserJson = await DatabaseHelper.instance.getSetting(_userKey);
      final savedActiveRole = await DatabaseHelper.instance.getSetting(_activeRoleKey);

      if (_token != null && cachedUserJson != null) {
        final Map<String, dynamic> data = jsonDecode(cachedUserJson);
        _currentUser = UserModel.fromJson(data, activeRole: savedActiveRole);

        // Verify/refresh user profile from server in background
        _refreshUserProfile();
        return _currentUser;
      }
    } catch (e) {
      debugPrint('[AuthService] Error restoring session: $e');
    }
    return null;
  }

  Future<void> _refreshUserProfile() async {
    if (_token == null) return;
    final candidates = await _getCandidateUrls();
    for (final candidate in candidates) {
      try {
        final url = Uri.parse('$candidate/auth/me');
        final res = await http.get(url, headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_token',
        }).timeout(const Duration(seconds: 4));

        if (res.statusCode == 200) {
          _baseUrl = candidate;
          final data = jsonDecode(res.body);
          _currentUser = UserModel.fromJson(data, activeRole: _currentUser?.activeRole);
          await DatabaseHelper.instance.setSetting(_userKey, jsonEncode(_currentUser!.toJson()));
          return;
        }
      } catch (_) {}
    }
  }

  /// Login with email and password (tries candidate URLs automatically)
  Future<UserModel> login({required String email, required String password}) async {
    final candidates = await _getCandidateUrls();
    String? lastError;

    for (final candidate in candidates) {
      try {
        final url = Uri.parse('$candidate/auth/login');
        final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'email': email.trim(), 'password': password}),
        ).timeout(const Duration(seconds: 6));

        if (response.statusCode == 200) {
          _baseUrl = candidate;
          final data = jsonDecode(response.body);
          _token = data['access_token'];
          final userMap = data['user'];
          _currentUser = UserModel.fromJson(userMap);

          await DatabaseHelper.instance.setSetting(_tokenKey, _token!);
          await DatabaseHelper.instance.setSetting(_userKey, jsonEncode(_currentUser!.toJson()));
          return _currentUser!;
        } else {
          lastError = _parseErrorMessage(response);
          // If server responded with 401 Unauthorized or 400 Bad Request, that's the real server responding!
          if (response.statusCode == 401 || response.statusCode == 400) {
            _baseUrl = candidate;
            throw Exception(lastError);
          }
        }
      } catch (e) {
        if (e.toString().contains('Invalid email or password')) rethrow;
        lastError = e.toString().replaceAll('Exception: ', '');
      }
    }

    throw Exception(lastError ?? 'Could not connect to backend server. Make sure "python app.py" is running.');
  }

  /// Register new user or farmer (tries candidate URLs automatically)
  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
    required String role, // 'user' or 'farmer'
  }) async {
    final candidates = await _getCandidateUrls();
    String? lastError;

    for (final candidate in candidates) {
      try {
        final url = Uri.parse('$candidate/auth/register');
        final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'name': name.trim(),
            'email': email.trim(),
            'password': password,
            'role': role,
          }),
        ).timeout(const Duration(seconds: 6));

        if (response.statusCode == 200) {
          _baseUrl = candidate;
          final data = jsonDecode(response.body);
          _token = data['access_token'];
          final userMap = data['user'];
          _currentUser = UserModel.fromJson(userMap);

          await DatabaseHelper.instance.setSetting(_tokenKey, _token!);
          await DatabaseHelper.instance.setSetting(_userKey, jsonEncode(_currentUser!.toJson()));
          return _currentUser!;
        } else {
          lastError = _parseErrorMessage(response);
          if (response.statusCode == 409 || response.statusCode == 400) {
            _baseUrl = candidate;
            throw Exception(lastError);
          }
        }
      } catch (e) {
        if (e.toString().contains('already exists') || e.toString().contains('Password')) rethrow;
        lastError = e.toString().replaceAll('Exception: ', '');
      }
    }

    throw Exception(lastError ?? 'Could not connect to backend server. Make sure "python app.py" is running.');
  }

  /// Set the user's active role context (e.g. switch between Farmer and User views)
  Future<void> setActiveRole(String role) async {
    if (_currentUser == null) return;
    _currentUser = _currentUser!.copyWith(activeRole: role);
    await DatabaseHelper.instance.setSetting(_activeRoleKey, role);
  }

  /// Logout and clear saved tokens
  Future<void> logout() async {
    _token = null;
    _currentUser = null;
    try {
      final db = await DatabaseHelper.instance.database;
      await db.delete('app_settings', where: 'key IN (?, ?, ?)', whereArgs: [_tokenKey, _userKey, _activeRoleKey]);
    } catch (_) {}
  }

  /// Fetch Farmer Dashboard Data (Protected by RBAC)
  Future<Map<String, dynamic>> getFarmerDashboard() async {
    if (_token == null) throw Exception('Authentication required.');
    final url = Uri.parse('$_baseUrl/farmer/dashboard');
    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $_token',
    }).timeout(const Duration(seconds: 8));

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else if (response.statusCode == 403) {
      throw Exception('Access Denied: Farmer or Admin permissions required.');
    } else {
      throw Exception(_parseErrorMessage(response));
    }
  }

  /// Add Farmer Crop Record (Protected by RBAC)
  Future<Map<String, dynamic>> addCropRecord({
    required String plantName,
    required String stage,
    String? expectedHarvest,
    String? quantity,
  }) async {
    if (_token == null) throw Exception('Authentication required.');
    final url = Uri.parse('$_baseUrl/farmer/crops');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_token',
      },
      body: jsonEncode({
        'plant_name': plantName,
        'stage': stage,
        'expected_harvest': expectedHarvest,
        'quantity': quantity,
      }),
    ).timeout(const Duration(seconds: 8));

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception(_parseErrorMessage(response));
    }
  }

  /// Admin: Fetch user directory (Protected by RBAC)
  Future<List<Map<String, dynamic>>> getAdminUsers() async {
    if (_token == null) throw Exception('Authentication required.');
    final url = Uri.parse('$_baseUrl/admin/users');
    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $_token',
    }).timeout(const Duration(seconds: 8));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final list = (data['users'] as List).cast<Map<String, dynamic>>();
      return list;
    } else if (response.statusCode == 403) {
      throw Exception('Access Denied: Admin privileges required.');
    } else {
      throw Exception(_parseErrorMessage(response));
    }
  }

  /// Admin: Verify or toggle farmer verification (Protected by RBAC)
  Future<void> toggleUserVerification(int userId, bool isVerified) async {
    if (_token == null) throw Exception('Authentication required.');
    final url = Uri.parse('$_baseUrl/admin/verify-user');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_token',
      },
      body: jsonEncode({
        'user_id': userId,
        'is_verified': isVerified,
      }),
    ).timeout(const Duration(seconds: 8));

    if (response.statusCode != 200) {
      throw Exception(_parseErrorMessage(response));
    }
  }

  String _parseErrorMessage(http.Response response) {
    try {
      final body = jsonDecode(response.body);
      if (body is Map && body.containsKey('detail')) {
        return body['detail'].toString();
      }
    } catch (_) {}
    return 'Server returned error status ${response.statusCode}';
  }
}
